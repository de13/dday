#/bin/bash -x
kubectl delete -f job-ab.yaml
kubectl create -f job-ab.yaml
watch -n 1 kubectl get pods 