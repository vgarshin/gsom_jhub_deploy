# GSOM JupyterHub: deploy and maintenance
Manual for Zero to JupyterHub with Kubernetes Deploy

## Introduction
https://github.com/jupyterhub/zero-to-jupyterhub-k8s

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

## Upgrade

Docker images, authorization

## More

https://github.com/vgarshin/gsom_jhub_manual
