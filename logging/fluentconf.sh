#!/usr/bin/env bash

cp configs3.yaml configs3_tmp.yaml

# file awscredentials.txt should contain
# data on aws key and aws secret like:
#
# AWS_ACCESS_KEY_ID_VALUE <aws_key>
# AWS_SECRET_ACCESS_KEY_VALUE <aws_secret>

while read cred; do
  credarr=($cred)
  sed -i "s/<${credarr[0]}>/${credarr[1]}/g" configs3_tmp.yaml
  echo Secret for ${credarr[0]} replaced
done < awscredentials.txt

kubectl apply -f configs3_tmp.yaml

rm configs3_tmp.yaml
