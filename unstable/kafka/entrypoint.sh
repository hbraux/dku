#!/bin/bash

function _setup {
  [[ -f .setup ]] && return
  sed -r -i 's~^log.dirs=.*~log.dirs=/data~' config/server.properties
  touch .setup
}

function _start {
  _setup
  # Starting Zookeeper
  if [[ $HEAP == low ]]
  then KAFKA_HEAP_OPTS="-Xmx32m -Xms32m" zookeeper-server-start.sh config/zookeeper.properties &
  else zookeeper-server-start.sh config/zookeeper.properties &
  fi
  while ! nc -z localhost 2181;  do sleep 1; done
  # starting kafka
  [[ $HEAP == low ]] && heapsize=256m
  egrep -q '[0-9]+[kmg]'<<<$HEAP && heapsize=$HEAP
  export KAFKA_HEAP_OPTS="-Xmx${heapsize} -Xms${heapsize}" 
  exec bin/kafka-server-start.sh config/server.properties
}


case $1 in
  start) _start;;
  *)     exec $@;;
esac

