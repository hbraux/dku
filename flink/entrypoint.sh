#!/bin/bash

function _setup {
  [[ -f .setup ]] && return
  sed -i 's/^#jobmanager.web.address:.*/jobmanager.web.address: 0.0.0.0/' conf/flink-conf.yaml
  sed -i 's~^# io.tmp.dirs: /tmp*~io.tmp.dirs: /data~' conf/flink-conf.yaml
  if [[ $HEAP == low ]]; then 
    sed -i 's/heap.size: 1024m/heap.size: 256m/g' conf/flink-conf.yaml
  fi
  touch .setup
}


function _start {
  _setup
  # load the env
  . /opt/flink/bin/config.sh
  TMSlaves start
  exec bin/jobmanager.sh start-foreground
  
}

export -f _setup _start

case $1 in
  start)   _start;;
  submit)  shift; flink run -d $@;;  
  *)       exec $@;;
esac

