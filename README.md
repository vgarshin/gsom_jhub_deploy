# GSOM JupyterHub: deploy and maintenance
Manual for Zero to JupyterHub with Kubernetes Deploy

## Introduction

This manual will get you through installation process of [JupyterHub for Kubernetes](https://github.com/jupyterhub/zero-to-jupyterhub-k8s/) on a cloud using [Kubernetes](https://kubernetes.io/) with [Helm](https://helm.sh/) and JupyterHub customization for use in [MiBA program](https://gsom.spbu.ru/en/programmes/graduate/miba/) technology oriented courses.

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

You may use the [manual](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/) that offers following steps:
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
...and you will get an access to the cluster:
```
kubectl get nodes
```
Setting the correct permissions for `<filename>.yaml`:
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

1. Clone this repository `git clone https://github.com/vgarshin/gsom_jhub_deploy` to the folder with `<filename>.yaml` file.
2. Create file e.g. with `nano mibacreds.txt` command.
3. Put all secrets to `mibacreds.txt` file in the following way:
```
SECRET_TOKEN <secret_token>
CLICKHOUSE_PASSWORD <click_password>
POSTGRESQL_PASSWORD <postgresql_password>
TENANT_ID <tenant_id>
CLIENT_ID <client_id>
CLIENT_SECRET <client_secret>
JUPYTERHUB_ADMIN <admin_name>
ADVANCED_HW_USERS <list_of_users_1>
DATA_FOLDER_USERS <list_of_users_2>
```
where:
-  `<secret_token>` can be generated with `openssl rand -hex 32` command
-  `<click_password>` and `<postgresql_password>` are passwords for databases (not necessary for this step, can be omitted)
-  `<tenant_id>`, `<client_id>`, `<client_secret>` are credentials for Azure AD authentification
-  `<admin_name>` is for admin user to manage JupyterHub in web interface
-  `<list_of_users_1>` is a list of users' logins (e.g. `["user_name1","stXXXXXX","stYYYYYY","stZZZZZZ"]` with no spaces between!) who can access to advanced configuration with more CPUs and RAM
-  `<list_of_users_2>` is a list of users' logins (e.g. `["user_name2","stAAAAAA","stBBBBBB","stCCCCCC"]` with no spaces between!) who can write to `__DATA` folder, other users can only read
4. Run `installjhub.sh` script to start installation process.
5. Run `kubectl -n jhubsir describe svc proxy-public` to get public IP address and register that address for `jhas01.gsom.spbu.ru` domain name.
6. After some time go to login JupyterHub page https://jhas01.gsom.spbu.ru to start work.

## Monitoring

To get access to MCS Kubernetes dashboard follow the instructions from [MCS manual](https://mcs.mail.ru/help/ru_RU/k8s-start/k8s-dashboard) and run the command:
```
kubectl proxy
```

You also may want to monitor health or debug the claster with the list of commands in the table below. They might be useful to discover basic troubles with the JupyterHub and the Kubernetes cluster:

| Command | Description |
|:---|:---|
| `kubectl get pod -n jhub` | Get list of all podes in `jhub` namespace |
| `kubectl get pod --all-namespaces` |  Get list of all podes in all namespaces |
| `kubectl get service -n jhub` | Get list of all services running in `jhub` namespace. In our cases these services are `hub`, `proxy-api`, `proxy-http` and `proxy-public` |
| `kubectl get events --all-namespaces  --sort-by='.metadata.creationTimestamp'` | Display logs from all namespaces sorted bt time |
| `kubectl get volumeattachment` | List all [PV](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) attached |
| `kubectl cluster-info` | Get full cluster info including `Kubernetes control plane` running address |
| `kubectl get nodes` | List all nodes and their status |
| `kubectl describe nodes` | Detailed description of all nodes in the cluster |
| `kubectl -n jhub get svc <service_name>` | Service `<service_name>` info (for `hub`, `proxy-api`, `proxy-http` and `proxy-public` services) in `jhub` namespace |
| `kubectl -n jhub describe pvc <pvc_name>` | Describe selected [PVC](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) with name `<pvc_name>` in `jhub` namespace |
| `kubectl -n jhub logs <pod_name>` | List logs from pod named `<pod_name>` in `jhub` namespace. Pod must be running to access to its logs |
| `kubectl logs <pod_name> -n jhub -c <container_name> --previous` | List logs from pod named `<pod_name>` in `jhub` namespace if many docker containers are in a pod, where `<container_name>` stands for a container to find. Note the key `--previous` for the logs of a previous container launch |
| `kubectl -n jhub exec -it <pod_name> /bin/bash` | Get access to shell `/bin/bash` of the running pod (container) `<pod_name>` in `jhub` namespace |

Full list of the possible `kubectl` commands can be found [in Kubernetes manual](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands).

## Customization

#### Environments

JupyterHub allows to customize user environment which is the set of software packages, environment variables, and various files that are present when the user logs in. Overall manual for customization options can be found [in Zero-to-JupyterHub manual](https://zero-to-jupyterhub.readthedocs.io/en/latest/jupyterhub/customizing/user-environment.html).

Current installation already offers a few environments:
- Data Science environment
- Spark environment
- R environment
- Minimal Python environment

All of the images for environments are taken or inherited from the [Jupyter docker stack collection](https://jupyter-docker-stacks.readthedocs.io/en/latest/using/selecting.html).

#### How to customize

Fisrt, there must be a docker installed. Here is example of [installation for Ubuntu](https://docs.docker.com/engine/install/ubuntu/):
```
sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io
```

In order to create a new environment you need to create a [Dockerfile](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/) first:
```
mkdir dockerfiledsai
nano dockerfiledsai/Dockerfile
```
Or you may edit one of existing Dockerfiles e.g. [this file](https://github.com/vgarshin/gsom_jhub_deploy/blob/master/dockerfiledsai/Dockerfile).

Next step are to [build a docker image](https://docs.docker.com/engine/reference/commandline/build/) and [push in to the registry](https://docs.docker.com/engine/reference/commandline/push/): 
```
sudo docker build -t <image_name> dockerfiledsai
sudo docker tag mibadsai <docker_id>/<image_name>:<image_tag>
sudo docker login
sudo docker push <docker_id>/<image_name>:<image_tag>
```

You also need to edit [config file](https://github.com/vgarshin/gsom_jhub_deploy/blob/master/mibaconfig.yaml):
```
image:
  name: <docker_id>/<image_name>
  tag: <image_tag>
```
...and upgrade JupyterHub by running the script `./upgradejhub.sh`.

## Troubleshooting

Some known troubleshootig cases are listed below. This cases occured during JupyterHub usage in MCS Kubernetes.

#### Case 1. No default storage class

There might be a case when default [Kubernetes storage classes](https://kubernetes.io/docs/concepts/storage/storage-classes/) are changed in MCS cloud. It may affect JupyterHub performance, so few actions are needed. 

First of all, list all storage classes to find `default` storage class:
```
export KUBECONFIG=~/<filename>.yaml
kubectl get storageclass
```
You may want to get detailed description of selected storage class e.g. `<some-storage-class>` in YAML format, so use a command below:
```
kubectl get storageclass <some-storage-class> -o yaml
```
There should be __only one default storage class__, therefore if you find no or few storage classes, you should patch existing classes with the command:

```
kubectl patch storageclass <some-storage-class> -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
```

#### Case 2. Topology mismatch

Topology mismatch appears if master node and nodes are created in different zones. 

You can check nodes to find topology (zone) labels:
```
export KUBECONFIG=~/<filename>.yaml
kubectl get nodes --show-labels
```
And the typical output is as follows:
```
NAME                     STATUS   ROLES    AGE     VERSION   LABELS
miba-kjh-01-group-01-0   Ready    <none>   6d15h   v1.17.8   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/instance-type=59f7faf3-d817-4cb8-ae69-8b4b92565f94,beta.kubernetes.io/os=linux,failure-domain.beta.kubernetes.io/zone=DP1,kubernetes.io/arch=amd64,kubernetes.io/hostname=miba-kjh-01-group-01-0,kubernetes.io/os=linux,mcs.mail.ru/mcs-nodepool=group-01,node.kubernetes.io/instance-type=59f7faf3-d817-4cb8-ae69-8b4b92565f94,topology.cinder.csi.openstack.org/zone=MS1,topology.kubernetes.io/zone=DP1
miba-kjh-01-master-0     Ready    master   278d    v1.17.8   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/instance-type=d659fa16-c7fb-42cf-8a5e-9bcbe80a7538,beta.kubernetes.io/os=linux,failure-domain.beta.kubernetes.io/zone=MS1,kubernetes.io/arch=amd64,kubernetes.io/hostname=miba-kjh-01-master-0,kubernetes.io/os=linux,node-role.kubernetes.io/master=,node.kubernetes.io/instance-type=d659fa16-c7fb-42cf-8a5e-9bcbe80a7538,role.node.kubernetes.io/master=,topology.cinder.csi.openstack.org/zone=MS1,topology.kubernetes.io/zone=MS1
```
Note the labels `zone=MS1` and `zone=DP1` that are not consistent for `miba-kjh-01-master-0` and `miba-kjh-01-group-01-0` nodes.


It is necessary to patch nodes and set the right label for zone e.g.:
```
kubectl label nodes miba-kjh-01-master-0 failure-domain.beta.kubernetes.io/zone=DP1 --overwrite=true
kubectl label nodes miba-kjh-01-master-0 topology.cinder.csi.openstack.org/zone=DP1 --overwrite=true
```

#### Case 3. Auto HTTPS is broken

Symptoms are bad certificate messages from the browser while trying to access `https://jhas01.gsom.spbu.ru`. The easy and straightforward solution is to restart pod with auto-https. At first step you can get logs from the auto-https pod:
```
$ kubectl logs autohttps-5fd5d5f7bf-tl9ml -n jhub -c traefik
```
Then there are two options, the first is to restart pod:
```
$ kubectl rollout restart deployment/autohttps --namespace=jhub
```
The second option is to force delete pod and wait it will be created after that:
```
$ kubectl delete pod autohttps-5fd5d5f7bf-tl9ml -n jhub  --grace-period=0  --force
```

## More

User's manual can be found [here](https://github.com/vgarshin/gsom_jhub_manual).
