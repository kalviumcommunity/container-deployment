# container-deployment

Local Cloud Computing assessment starter.


## Environment and zero-cost boundary

Use Python 3.10+, Git, curl and an instructor-preinstalled free OCI engine with Compose.
Canonical free route: Linux Docker Engine (or instructor-tested Podman compatibility).
macOS may use free Colima/Lima; Docker Desktop is optional only if free use is permitted
by its license. No paid account, cloud project, registry login, trial credits or hosted CI.
Application images use Python 3.12.12 and the standard library only. Base images are pinned
to verified multi-architecture digests. Initial public image downloads need internet; instructor
should preload/cache images for the exam to avoid rate limits. Local power, hardware and
internet are assumed, not supplied. Use a free text editor, diagrams.net/Excalidraw or plain
Markdown for diagrams; export PDF with a free browser/office suite. No paid PDF tool required.

Reference environment: macOS arm64, Docker Engine 29.4.3, kind 0.30.0 local Kubernetes
v1.34.0. Docker Desktop was the host engine, not a mandatory licensed dependency. This records the author's test environment, not a requirement to purchase Docker
Desktop. Other runtime/OS combinations need instructor validation. Linux/WSL2 recommended
for native CLI commands; use WSL paths for executable shell scripts. Run shell scripts from
repository root. chmod +x scripts/*.sh if an archive lost executable bits.

Practical host allowance: 4 CPU, 8 GB RAM, 8 GB free disk for container-only work; 4 CPU,
12 GB RAM, 12 GB free disk for Kubernetes work (allocate >=4 GB to the engine). These are
planning recommendations, not measured minimums. Instructor installs tools and warms caches
before the timed assessment. Allow a provisional 2-3 hour practical window, then calibrate
with a representative student; this is not a measured student completion time.

There are five planted assessment issues, one per task. Setup and tools are not extra faults.
Some symptoms interact. Use the task ordering below and static checks to diagnose tasks even
when earlier runtime work is incomplete. Do not delete checks, force success or change the
specified ports/contracts. Exercise cloud policy models are design validation only, not real
GCP enforcement. Keep your changes and evidence scoped to this repository.

Read [STUDENT_TASKS.md](STUDENT_TASKS.md) for the exact assessment and rubric.

## Evidence and safe cleanup

Start from reports/report-template.md and release-notes.md. Store local transcripts under
ignored evidence/. Never commit real secrets, generated plans/state or local .env. Fake demo
identity strings end in example.invalid. No real GCP operations are performed.
Run scripts/cleanup.sh when finished; it deletes only this exercise's services/namespace.
Do not run system-wide docker prune, reset Kubernetes or delete unrelated namespaces.

## Workflow and local cluster prerequisites

Instructor supplies kubectl plus a healthy local kind, minikube or Docker Desktop cluster.
No remote/cloud cluster allowed. For kind use >=0.27; a tested local image loader and dynamic
storage provisioner are required. Instructor must confirm a scratch PVC binds and a non-root
UID 10001 can write it before the exam. This is prerequisite setup, not another planted fault.
kind's node/runtime infrastructure may be privileged; students do not need sudo or privileged
application Pods. Do not install a new cluster during the timed assessment.

```bash
./scripts/check-prereqs.sh
kubectl cluster-info
docker build -t container-deployment:1.0.0 .
./scripts/load-image.sh
./scripts/apply.sh
kubectl -n container-deployment get pods,pvc,svc
kubectl -n container-deployment describe deployment cloudnotes
kubectl -n container-deployment get events --sort-by=.lastTimestamp
python3 checks/check.py service
python3 checks/check.py config
```

Task 1 must permit image build before Task 2 loads it. Task 2 checks exact local image tag;
kind uses kind load docker-image, minikube uses minikube image load, Docker Desktop checks
may have a separate image store and is refused unless instructor preloads/verifies it. Canonical tested route is kind. No image push or registry login. Re-run scripts/apply.sh after changes.
Task 3 uses Service selectors and EndpointSlices, not direct Pod forwarding:

```bash
kubectl -n container-deployment get pods --show-labels
kubectl -n container-deployment get endpointslice -l kubernetes.io/service-name=cloudnotes
kubectl -n container-deployment port-forward service/cloudnotes 18082:8080 --address 127.0.0.1
```

Keep forwarding in a separate terminal. It only works after Pods are Ready. Task 4 affects
readiness too; inspect static selectors/key references independently if a previous fault blocks
traffic. Once configuration is repaired:

```bash
curl --fail http://127.0.0.1:18082/info
curl --fail -H 'Content-Type: application/json' -d '{"body":"persistence proof"}' http://127.0.0.1:18082/notes
curl --fail http://127.0.0.1:18082/notes
kubectl -n container-deployment delete pod -l app=cloudnotes
kubectl -n container-deployment rollout status deployment/cloudnotes --timeout=120s
```

Restart port-forward after Pod replacement; verify the same saved note remains. One replica,
Recreate strategy and an instructor-provisioned local PVC avoid unsupported concurrent SQLite
writers. This tests Pod replacement, not node/region disaster recovery. Secret contains only
a visibly fake demo value; do not replace it with a real password.

Task 5: scripts/verify-release.sh must fail with a nonzero exit for an unreachable endpoint and
pass against the repaired Service. Test exit code, not just printed text:

```bash
BASE_URL=http://127.0.0.1:1 ./scripts/verify-release.sh; echo "exit=$?"
./scripts/verify-release.sh; echo "exit=$?"
kubectl -n container-deployment rollout history deployment/cloudnotes
```

To test rollback, create a controlled disposable revision and use rollout undo, then verify.
Do not expect an old revision to exist on a fresh deployment. No hosted CI is required.
