#!/usr/bin/env bash

# use in crontab
# 0 21 * * * /home/simbauser/jhub/utils/hubdrain.sh >> /home/simbauser/jhub/utils/hubdrain.log 2> /home/simbauser/jhub/utils/hubdrainerr.log
# to drain at 00:00 Moscow time
# or 0 */12 * * *  - to run every 12 hours

echo $(date) - drain script started
kubectl get node -n jhub | while read s; do
  ws=($s)
  if [[ ${ws[0]} != NAME ]]; then
    np=$(kubectl get pods -o wide -n jhub | grep ${ws[0]} | grep -v hubdrain-cronjob | wc -l)
    npup=$(kubectl get pods -o wide -n jhub | grep ${ws[0]} | grep -o 'user-placeholder' | wc -l)
    if [[ $((${np}-${npup})) > 1 ]]; then
      echo $(date) - node ${ws[0]} has $((${np}-${npup})) podes in jhub namespace
    else
      echo $(date) - node ${ws[0]} has no user pods in jhub namespace and will be drained
      /usr/bin/kubectl drain ${ws[0]} --ignore-daemonsets --delete-emptydir-data --force
    fi
  fi
done
