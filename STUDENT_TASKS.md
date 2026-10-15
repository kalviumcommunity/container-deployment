CloudNotes has been packaged for local Kubernetes, but its build, image reference, service routing and configuration fail release checks. Repair the delivery path from source to a reachable, persistent local workload. The supplied GKE diagram is background only; no GKE cluster is required.

You are the cloud engineer. Repair the supplied repository, validate the results locally and document the evidence in one PDF. All five tasks are compulsory. No cloud account, billing, paid registry, hosted CI or real secret is needed.

## Broken repository: fork and clone first

**Repository:** `https://github.com/kalviumcommunity/container-deployment`

1. Open the repository and click **Fork**, or use the instructor-provided offline starter.
2. Clone your fork and create a branch:

```bash
git clone https://github.com/<your-username>/container-deployment.git
cd container-deployment
git checkout -b fix/assessment
```

3. Read `README.md` for the tested local setup, commands and checks.
4. Capture the initial failures before editing. Do not delete or bypass checks.

## Task 1 - Repair the multi-stage image build

Reproduce the Dockerfile build failure and fix the incorrect dependency-file path. Preserve the multi-stage structure and non-root runtime. Build cloudnotes-set2:1.0.0 and verify /health locally. Include failure output, diff, image size and working response.

**Evidence:** Original failure, relevant corrected file/diff, actual verification output and a short explanation.

## Task 2 - Repair the local image delivery script

Repair scripts/load-image.sh so it builds/tags and loads the exact image expected by the supplied kind cluster. Use the supplied local-context image loader rather than an external registry. Verify the local tag and cluster image inventory. Explain how Artifact Registry would replace this local handoff in GCP without using it here.

**Evidence:** Original failure, relevant corrected file/diff, actual verification output and a short explanation.

## Task 3 - Repair Kubernetes Service routing

Apply the provided Deployment and Service. Use kubectl get pods, kubectl describe service and EndpointSlice inspection to diagnose why the Service has no matching ready backends. Correct only the broken selector. Verify /health through Service port-forward, not direct Pod port-forward. Include before/after selector and endpoint evidence.

**Evidence:** Original failure, relevant corrected file/diff, actual verification output and a short explanation.

## Task 4 - Repair configuration consumption

Diagnose the missing ConfigMap key using events/describe. Fix the Deployment reference to the existing APP_MODE key without hardcoding configuration in the image. Keep the supplied Secret reference and PVC unchanged. Prove the configured mode is reported by /info and that a saved note survives replacement of the single application Pod.

**Evidence:** Original failure, relevant corrected file/diff, actual verification output and a short explanation.

## Task 5 - Repair the release verification gate

Fix scripts/verify-release.sh so a failing health/notes test returns nonzero rather than reporting success. Prove the gate fails against a known-unreachable test endpoint and passes against the repaired Service. Include final image-to-Deployment diagram and rollback/rebuild commands. Explain build/release gate correctness and Kubernetes routing/configuration verification.

**Evidence:** Original failure, relevant corrected file/diff, actual verification output and a short explanation.

## Submission guidelines

Upload one PDF containing:

- name, section, environment/tool versions and forked repository URL or offline starter identifier;
- one labelled architecture or request-path diagram;
- Task 1 to Task 5 evidence, readable code/configuration excerpts and actual command output;
- original issue -> diagnosis -> fix -> verification summary;
- remaining limitations and the rebuild/cleanup procedure.

Use fake values only. Do not include real credentials, tokens, private keys, raw Terraform state or local secret files. A screenshot is not sufficient without the diagnosis and explanation. Equivalent valid commands are accepted. If a tool is unavailable, show the actual error and corrected files; static reasoning can earn applicable partial credit, but must not be presented as a passed runtime test.

## Simple evaluation rubric - 40 marks

| Marks | Criterion | Award marks for |
|---:|---|---|
| 8 | Image build | Correct dependency-file reference; working multi-stage non-root image and health response. |
| 8 | Local image delivery | Matching build/load/workload tag and proof the local cluster can use the image. |
| 8 | Service routing | Correct selectors, ready endpoints and successful Service-level request. |
| 8 | Configuration and persistence | Valid ConfigMap reference, reported app mode and saved note surviving Pod replacement. |
| 8 | Release gate | Unreachable endpoint fails gate; healthy workload passes; repeatable rebuild/rollback explanation. |

Award partial credit for correct diagnosis, repair and verification even when another task remains incomplete. Assess technical correctness and evidence of working behavior, not grammar, screenshot aesthetics or one prescribed wording. Task 5 has equal module shares; accept equivalent technically valid solutions.
