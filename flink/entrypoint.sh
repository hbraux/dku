#!/bin/bash

function _setup {
  [[ -f .setup ]] && return
  sed -i -e 's/^#jobmanager.web.address:.*/jobmanager.web.address: 0.0.0.0/' conf/flink-conf.yaml
  touch .setup
}


function _start {
  _setup
  exec bin/jobmanager.sh start-foreground
}

export -f _setup _start

case $1 in
  start) _start;;
  *)       exec $@;;
esac

