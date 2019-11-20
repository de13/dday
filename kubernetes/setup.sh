#! /bin/bash -x
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
kubectl create configmap hack --from-file=hack.sh
kubectl create -f 00-prereq.yaml
kubectl create -f 01-cdi-operator.yaml
kubectl wait --for=condition=available --timeout=600s deployment/cdi-operator -n cdi
kubectl create -f 02-cdi-cr.yaml
kubectl create -f 03-dataVolume.yaml
kubectl create -f 04-kubevirt-operator.yaml
kubectl wait --for=condition=available --timeout=600s deployment/virt-operator -n kubevirt
kubectl create -f 05-kubevirt-cr.yaml
kubectl create -f 10-hello.yaml