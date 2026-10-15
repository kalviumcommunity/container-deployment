#!/bin/sh
set -eu
python3 checks/local-context.py
echo "Deletes only namespace container-deployment; its exercise PVC data will be lost."
kubectl delete namespace container-deployment --ignore-not-found --wait=true
