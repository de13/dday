#! /bin/bash -x
kubectl delete -f 1-kubevirt/ingress.yaml
kubectl delete -f 1-kubevirt/cloud-init_debian.yaml
kubectl delete -f 03-dataVolume.yaml
kubectl delete svc ingress-nginx -n ingress-nginx