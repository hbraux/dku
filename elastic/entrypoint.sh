#!/bin/bash

function _setup {
  [[ -f .setup ]] && return
  [[ $HEAP == low ]] && HEAPSIZE=128m
  egrep -q '[0-9]+[kmg]'<<<$HEAP && HEAPSIZE=$HEAP

  [[ -n $HEAPSIZE ]] && sed -i -e "s/^-Xms.*/-Xms${HEAPSIZE}/;s/^-Xmx.*/-Xmx${HEAPSIZE}/" config/jvm.options

  # starting Elastic in production mode for connectivity purpose 
  # See https://www.elastic.co/guide/en/elasticsearch/reference/5.2/bootstrap-checks.html#_development_vs_production_mode
  cat>>config/elasticsearch.yml <<EOF
cluster.name: ${ELASTICSEARCH_CLUSTERNAME}
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

