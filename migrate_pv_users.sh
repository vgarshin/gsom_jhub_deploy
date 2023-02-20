#!/bin/bash

while read line; do
  echo "* * * * * * * * * * * * * * * * * *"
  echo "Start user ${line} PV copying......"
  echo "claim name: claim-${line}"
  pv-migrate migrate \
    --source-kubeconfig ./miba-kjh-01_kubeconfig.yaml \
    --source-namespace jhub \
    --dest-kubeconfig ../.kube/config \
    --dest-namespace jhub \
    --strategies local \
    claim-${line} claim-${line}
  echo "User's ${line} PV copying FINISHED"
done < jhub_users.txt
