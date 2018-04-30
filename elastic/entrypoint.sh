#!/bin/bash

function _setup {
  [[ -f .setup ]] && return
  HEAP_SIZE=${HEAP:-128m}
  sed -r -i "s/(^-Xms.*)/-Xms${HEAP_SIZE}/" config/jvm.options
  sed -r -i "s/(^-Xmx.*)/-Xmx${HEAP_SIZE}/" config/jvm.options
  # starting Elastic in production mode for connectivity purpose (https://www.elastic.co/guide/en/elasticsearch/reference/5.2/bootstrap-checks.html#_development_vs_production_mode)
  cat>>config/elasticsearch.yml <<EOF
cluster.name: $CLUSTER_NAME
path.data: /data
network.host: [_eth0_]
EOF
  touch .setup
}
export -f _setup # testing

function _start {
  _setup
  exec elasticsearch
}


case $1 in
  start) _start;;
  *)       exec $@;;
esac

