#!/bin/bash

function _setup {
  [[ -f .setup ]] && return

  # Warning, in sandalone mode, HBASE use random ports. See https://stackoverflow.com/questions/43524733/how-to-specify-rpc-server-port-for-hbase
 cat > conf/hbase-site.xml <<EOF
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
 <property>
  <name>hbase.rootdir</name>
  <value>file:////data</value>
 </property>
 <property>
  <name>hbase.rest.port</name>
  <value>${REST_PORT}</value>
 </property>
</configuration>
EOF
  touch .setup
}

function _setupcli {
  cat > conf/hbase-site.xml <<EOF
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
 <property>
  <name>hbase.zookeeper.quorum</name>
  <value>${SERVER_NAME}</value>
 </property>
</configuration>
EOF
}

function _start {
  _setup
  if [[ $HEAP == low ]]
  then HBASE_HEAPSIZE=32m bin/hbase rest start  &
  else bin/hbase rest start  &
  fi
  [[ $HEAP == low ]] && HBASE_HEAPSIZE=128m
  egrep -q '[0-9]+[kmg]'<<<$HEAP && HBASE_HEAPSIZE=$HEAP
  export HBASE_HEAPSIZE
  exec bin/hbase master start
}



case $1 in
  start) _start;;
  shell)   _setupcli; exec bin/hbase shell;;
  *)       exec $@;;
esac

