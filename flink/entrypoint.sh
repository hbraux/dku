#!/bin/bash


function _setup {
  [[ -f .setup ]] && return
  # sed -i 's/^#jobmanager.web.address:.*/jobmanager.web.address: 0.0.0.0/' $FLINK_HOME/conf/flink-conf.yaml
  [[ -n $FLINK_IO_TMPDIR ]] && echo "io.tmp.dirs: $FLINK_IO_TMPDIR" >> $FLINK_HOME/conf/flink-conf.yaml
  touch .setup
}


function _start {
  _setup
  # bin/taskmanager.start not working !? W/A:
  . /opt/flink/bin/config.sh
  TMSlaves start
  exec bin/jobmanager.sh start-foreground
  
}


function _submit {
  shift
  jar=$1
  shift
  if [[ $1 == -c ]]; then
    shift
    mainclass=$1
    shift
    flink run -c $mainclass $jar $@
  else
    flink run -d $jar $@
  fi
}


case $1 in
  start)   _start;;
  submit)  _submit $@;;  
  *)       exec $@;;
esac
