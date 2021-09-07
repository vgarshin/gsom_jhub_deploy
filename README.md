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

### STEP 3. Some prerequsites

In order to start JupyterHub in a configuration for GSOM students you should do it first:
1. Ensure the OAuth integration with GSOM Azure AD is possible and JupyterHub application is registred in GSOM Azuse AD. As the result, you should get `<tenant_id>`,
 `<client_id>` and `<client_secret>` from AD administrator for further steps.
2. Domaim name e.g. `jhas01.gsom.spbu.ru` is available to register.
 

### STEP 4. Install JupyterHub

With a cluster available, `kubectl` and  `Helm` installed, you can install JupyterHub with [the following commands](https://zero-to-jupyterhub.readthedocs.io/en/latest/jupyterhub/installation.html) below. The process is based on the manual recomendations but with some additions.

#### 1. Clone this repository `git clone https://github.com/vgarshin/gsom_jhub_deploy` to the folder with `<filename>.yaml` file.
2. Create file e.g. with `nano mibacreds.txt` command.
3. Put all secrets to `mibacreds.txt` file in the following way:
```
SECRET_TOKEN <secret_token>
CLICKHOUSE_PASSWORD <click_password>
POSTGRESQL_PASSWORD <postgresql_password>
TENANT_ID <tenant_id>
CLIENT_ID <client_id>
CLIENT_SECRET <client_secret>
```
where:
-  `<secret_token>` can be generated with `openssl rand -hex 32` command
-  `<click_password>` and `<postgresql_password>` are passwords for databases (not necessary for this step, can be omitted)
-  `<tenant_id>`, `<client_id>`, `<client_secret>` are credentials for Azure AD authentification
4. Run `installjhub.sh` script to start installation process.
5. Run `kubectl -n jhubsir describe svc proxy-public` to get public IP address and register that address for `jhas01.gsom.spbu.ru` domain name.
6. After some time go to login JupyterHub page https://jhas01.gsom.spbu.ru to start work.

## Monitoring

MCS Kubernetes dashboard:
```
kubectl proxy
```

Other commands:
```
kubectl get pod --namespace jhub
kubectl get pod --all-namespaces
kubectl get service --namespace jhub
kubectl get events --all-namespaces  --sort-by='.metadata.creationTimestamp'
kubectl get volumeattachment
kubectl cluster-info
kubectl describe
kubectl api-resources
kubectl describe nodes
kubectl --namespace=jhub get svc proxy-public
kubectl -n jhubsir describe svc hub-857d5c566b-xf8f8
kubectl -n jhubsir describe svc hub
kubectl -n jhubsir describe svc proxy-public
kubectl -n jhubsir describe pvc hub-db-dir
kubectl --namespace=jhub logs hub-797b7b767-dmqnq
kubectl logs csi-cinder-nodeplugin-b4l48 -n kube-system -c node-driver-registrar --previous # if many dockers in a pod
kubectl --namespace=jhub exec -it jupyter-vgarshin /bin/bash
```

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
