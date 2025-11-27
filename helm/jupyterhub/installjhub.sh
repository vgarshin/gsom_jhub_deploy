#!/usr/bin/env bash

RELEASE=jhub
NAMESPACE=jhub
JHVER=4.0.0

cp mibaconfig.yaml mibaconfig_tmp.yaml

while read cred; do
  credarr=($cred)
  sed -i "s|<${credarr[0]}>|${credarr[1]}|g" mibaconfig_tmp.yaml
  echo Secret for ${credarr[0]} replaced
done < mibacreds.txt

helm upgrade --cleanup-on-fail \
  --install $RELEASE jupyterhub/jupyterhub \
  --namespace $NAMESPACE \
  --create-namespace \
  --version=${JHVER} \
  --values mibaconfig_tmp.yaml \
  --debug

rm mibaconfig_tmp.yaml
