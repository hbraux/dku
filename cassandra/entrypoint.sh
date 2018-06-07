#!/bin/bash

function _setup {
  [[ -f .setup ]] && return

  cfgfile=/opt/cassandra/conf/cassandra.yaml
  cat>>$cfgfile<<EOF
data_file_directories:
   - /data
EOF
  ip=$(hostname -i)
  sed -i "s/rpc_address: localhost/rpc_address: $ip/" $cfgfile
  sed -i "s/broadcast_rpc_address:localhost/broadcast_rpc_address: $ip/" $cfgfile
  sed -i "s/listen_address: localhost/listen_address: $ip/" $cfgfile
  sed -i "s/seeds: \"127.0.0.1\"/seeds: \"$ip\"/" $cfgfile

  touch .setup
}

function _start {
  _setup

  [[ $HEAP == low ]] && HEAPSIZE=128m
  egrep -q '[0-9]+[kmg]'<<<$HEAP && HEAPSIZE=$HEAP
  [[ -n $HEAPSIZE ]] && cat>>/opt/cassandra/conf/jvm.options<<EOF
-Xms$HEAPSIZE
-Xmx$HEAPSIZE
EOF

  exec bin/cassandra -f
}

export -f _setup _start

case $1 in
  start) _start;;
  cqlsh)  exec bin/cqlsh cassandra 9042;;
  *)      exec $@;;
esac

