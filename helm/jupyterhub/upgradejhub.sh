#!/usr/bin/env bash

RELEASE=jhub
NAMESPACE=jhub
JHVER=4.0.0

# Temp file with credentials
cp simbaconfig.yaml simbaconfig_tmp.yaml

# Copy credentials to YAML configuration file
while read cred; do
  credarr=($cred)
  sed -i "s|<${credarr[0]}>|${credarr[1]}|g" simbaconfig_tmp.yaml
  echo Secret for ${credarr[0]} replaced
done < simbacreds.txt

# Use flag `--debug` for detailed upgrade monitoring
helm upgrade --cleanup-on-fail \
  ${RELEASE} jupyterhub/jupyterhub \
  --namespace ${NAMESPACE} \
  --version=${JHVER} \
  --values simbaconfig_tmp.yaml

rm simbaconfig_tmp.yaml
