#!/bin/bash

function _setup {
  [[ -f .setup ]] && return

  cat > conf/hbase-site.xml <<EOF
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
 <property>
  <name>hbase.rootdir</name>
  <value>file:////data</value>
 </property>
 <property>
  <name>hbase.rest.port</name>
  <value>16000</value>
 </property>
</configuration>
EOF
  touch .setup
}
export -f _setup # testing purpose

function _setupcli {
  cat > conf/hbase-site.xml <<EOF
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
 <property>
  <name>hbase.zookeeper.quorum</name>
  <value>hbase-server</value>
 </property>
</configuration>
EOF
}

function _start {
  _setup
  if [[ $DOCKER_PROFILE == slim ]]
  then HBASE_HEAPSIZE=32m bin/hbase rest start  &
  else bin/hbase rest start  &
  fi
  [[ $DOCKER_PROFILE == slim ]] && HBASE_HEAPSIZE=128m
  egrep -q '[0-9]+[kmg]'<<<$DOCKER_PROFILE && HBASE_HEAPSIZE=$DOCKER_PROFILE
  export HBASE_HEAPSIZE
  exec bin/hbase master start
}



case $1 in
  start) _start;;
  shell)   _setupcli; exec bin/hbase shell;;
  *)       exec $@;;
esac

