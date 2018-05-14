#!/bin/bash

function _setup {
  [[ -f .setup ]] && return
  #notthing to configure
  touch .setup
}

function _start {
  _setup
  export SPARK_HOME=/opt/spark
  heapsize=512m
  [[ $HEAP == low ]] && heapsize=256m
  egrep -q '[0-9]+[kmg]'<<<$HEAP && heapsize=$HEAP
  sparkjar=$(ls /opt/spark/lib/spark-assembly-*.jar)
  java -cp /opt/spark/conf/:$sparkjar -Xms${heapsize} -Xmx${heapsize} org.apache.spark.deploy.worker.Worker spark://spark:7077 &
  exec java -cp /opt/spark/conf/:$sparkjar -Xms${heapsize} -Xmx${heapsize} org.apache.spark.deploy.master.Master -h spark --webui-port 7080
}


case $1 in
  start)  _start;;
  *)     exec $@;;
esac

