# GSOM JupyterHub: deploy and maintenance
Manual for Zero to JupyterHub with Kubernetes Deploy

## Introduction

This manual will get you through installation process of [JupyterHub for Kubernetes](https://github.com/jupyterhub/zero-to-jupyterhub-k8s) on a cloud using [Kubernetes](https://kubernetes.io) with [Helm](https://helm.sh) and  JupyterHub customization for use in [MiBA program](https://gsom.spbu.ru/en/programmes/graduate/miba/) technology oriented courses.

You also may find [The Zero to JupyterHub with Kubernetes guide](https://zero-to-jupyterhub.readthedocs.io) for detais and it  is complemented well by the documentation for [JupyterHub](https://jupyterhub.readthedocs.io).

## Cloud environment setup

https://mcs.mail.ru/help/ru_RU/k8s-start/create-k8s

## Installation

kubectl install
```
sudo apt-get update && sudo apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo bash -c 'echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list'
sudo apt-get update && sudo apt-get install -y kubectl
cat filename.yaml
export KUBECONFIG=~/filename.yaml
kubectl proxy
kubectl get nodes
```

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
