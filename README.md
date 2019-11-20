# Devops D-Day

## Info

This lab presents 3 activities:

- Kubevirt
- Pod Horizontal Autoscaler
- Kata Containers

The instructions below explain how to set up the environment:

```
$ git clone git clone git@bitbucket.org:dataessential/dday.git
$ cd dday
$ export GOOGLE_CLOUD_KEYFILE_JSON="/Users/sbeuret/dday/dday-project-39276-3b4467fd2113.json"
```

The `dday-project-39276-3b4467fd2113.json` file is not in the bitbucket repository for security reasons. It must be downloaded from the dday-project-39276 project in the Google Cloud console.

```
$ terraform init
$ terraform apply
$ cd kubeadm
```

This command creates an instance group composed by 3 instances in the us-central1 region (the latter was chosen to be able to benefit from the cpu prerequisites of this lab).

Once the infrastrecture is deployed, it is necessary to retrieve the external ip address of the first instance and update the `certSans` field in `gce.yaml`, as well as the internal ip address that will have to be placed in the file. `join.yaml`.

```yaml
# gce.yaml
apiServer:
  certSANs:
  - 34.67.34.223 # change this
```

```yaml
# join.yaml
discovery:
  bootstrapToken:
    apiServerEndpoint: "10.128.0.16:6443" # change this
```

## Master

Copy (scp) on the first node the `gce.yaml` and `cloud-config` files and connect (ssh) to the instance:

```
$ sudo mv cloud-config /etc/kubernetes/
$ sudo kubeadm init --config gce.yaml
$ mkdir -p $HOME/.kube
$ sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
$ sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

Once the node configuration is complete, retrieve the config file locally:

```
$ scp stephane@MASTER:~/.kube/config .
$ export KUBECONFIG=$(pwd)/config
```

It is also necessary to modify the IP address of the API server in the file, and to replace the internal address by the external one.

```yaml
# ~/.kube/config
clusters:
- cluster:
    certificate-authority-data: DATA+OMITTED
    server: https://34.67.34.223:6443 # change this
```

## Worker

On the other two nodes, you need to copy the `join.yaml` and `cloud-config` files and connect to them:

```
$ sudo mv cloud-config /etc/kubernetes/
$ sudo kubeadm join --config join.yaml
```

## Prereq

Once the cluster is ready, there are still a few steps to configure it: Network add-on, StorageClass, Ingress Controller, Metric Server:

```
$ cd ../kubernetes
$ ./setup.sh
```

## LoadBalancer

The ingress rule in `1-kubevirt/ingress.yaml` must be updated with the load balancer ip address.

```yaml
spec:
  rules:
    - host: nginx.34.70.102.106.xip.io # change this
```