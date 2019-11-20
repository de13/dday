#!/bin/bash
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
kubectl apply -f cloud-init_debian.yaml
sleep 5
kubectl virt console debian9
