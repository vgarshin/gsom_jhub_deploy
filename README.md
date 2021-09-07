# GSOM JupyterHub: deploy and maintenance
Manual for Zero to JupyterHub with Kubernetes Deploy

## Introduction

This manual will get you through installation process of [JupyterHub for Kubernetes](https://github.com/jupyterhub/zero-to-jupyterhub-k8s/) on a cloud using [Kubernetes](https://kubernetes.io/) with [Helm](https://helm.sh/) and  JupyterHub customization for use in [MiBA program](https://gsom.spbu.ru/en/programmes/graduate/miba/) technology oriented courses.

You also may find [The Zero to JupyterHub with Kubernetes guide](https://zero-to-jupyterhub.readthedocs.io/) for detais and it  is complemented well by the documentation for [JupyterHub](https://jupyterhub.readthedocs.io/).

## Cloud environment setup

Kubernetes cluster must be created as a first step to deploy JupyterHub. The process how to create cluster at [MCS](https://mcs.mail.ru/) is decribed in [MCS Kubernetes manual](https://mcs.mail.ru/help/ru_RU/k8s-start/create-k8s/).

Recommended parameters of a cluster are as follows:
- master node: 2 vCPU / 4 GB RAM / 32 GB disk space (SSD type recommended)
- node group: 16 vCPU / 64 GB RAM / 64 GB disk space (SSD type recommended)

Note that for a node group there should be autoscaling enable with node number up to 100 (10 recommended).

There will be a configuration file `<filename>.yaml` available after the cluster is created. You will need this file in order to get access to the cluster.

## Installation

### STEP 1. Install kubectl

You may use the manual that offers following steps:
kubectl install
```
sudo apt-get update && sudo apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo bash -c 'echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list'
sudo apt-get update && sudo apt-get install -y kubectl
```
After install process finishes you will need `<filename>.yaml` uploaded to the host with `kubectl` client:
```
export KUBECONFIG=~/<filename>.yaml
```
After that you will get an access to the cluster:
```
kubectl get nodes
```
Set the correct permissions for `<filename>.yaml`:
```
chmod g-r arkh-kjh-01_kubeconfig.yaml
chmod o-r arkh-kjh-01_kubeconfig.yaml
```

### STEP 2. Install Helm

It is recommended to follow [the documentation](https://zero-to-jupyterhub.readthedocs.io/en/latest/kubernetes/setup-helm.html):
```
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
```
Check if `Helm` is installed:
```
helm list
```

### STEP 3. Install JupyterHub

With a cluster available, `kubectl` and  `Helm` installed, you can install JupyterHub with [the following commands](https://zero-to-jupyterhub.readthedocs.io/en/latest/jupyterhub/installation.html) below.

Generate secret for JyputerHub config file:
```
openssl rand -hex 32
```
and create config file with e.g. `nano mibaconfig.yaml' command. Configuration file shoul contain:
```
proxy:
  secretToken: "<output of 'openssl rand -hex 32' command>"
```


$ helm repo add jupyterhub https://jupyterhub.github.io/helm-chart/
$ helm repo update
$ nano jhubhelminstall.sh
RELEASE=jhub
NAMESPACE=jhub

helm upgrade --cleanup-on-fail \
  --install $RELEASE jupyterhub/jupyterhub \
  --namespace $NAMESPACE \
  --create-namespace \
  --version=0.9.0 \
  --values config.yaml
$ chmod +x jhubhelminstall.sh
$ ./jhubhelminstall.sh
$ helm list -n jhub
NAME    NAMESPACE       REVISION        UPDATED                                 STATUS          CHART                   APP VERSION
jhub    jhub            105             2021-08-18 09:49:31.82288031 +0000 UTC  deployed        jupyterhub-0.11.1       1.3.0

## Monitoring



## Upgrade

Docker images, authorization

## Troubleshooting

trouble with the default storage class
```
kubectl get storageclass
kubectl get storageclass csi-ceph-ssd-dp1 -o yaml
kubectl patch storageclass csi-ceph-ssd-dp1 -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
```

## More

https://github.com/vgarshin/gsom_jhub_manual
