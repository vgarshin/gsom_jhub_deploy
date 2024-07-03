#!/usr/bin/env bash

pv-migrate migrate \
  --source-kubeconfig ./miba-kjh-01_kubeconfig.yaml \
  --source-namespace jhub \
  --dest-kubeconfig ../.kube/config \
  --dest-namespace jhub \
  --strategies local \
  claim-st102710 claim-st102710
