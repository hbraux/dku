#!/bin/bash

function _setup {
  [[ -f .setup ]] && return

  cfgfile=conf/cassandra.yaml
  cat>>$cfgfile<<EOF
data_file_directories:
   - /data
EOF
  ip=$(hostname -i)
  sed -i "s/rpc_address:.*/rpc_address: $ip/;s/broadcast_rpc_address:.*/broadcast_rpc_address: $ip/;s/listen_address:.*/listen_address: $ip/" $cfgfile
  sed -i "s/seeds:.*/seeds: \"$ip\"/" $cfgfile

  [[ $HEAP == low ]] && HEAPSIZE=128m
  egrep -q '[0-9]+[kmg]'<<<$HEAP && HEAPSIZE=$HEAP
  [[ -n $HEAPSIZE ]] && cat>>conf/jvm.options<<EOF
-Xms$HEAPSIZE
-Xmx$HEAPSIZE
EOF

  touch .setup
}

function _start {
  _setup
  exec bin/cassandra -f
}

export -f _setup _start

case $1 in
  start) _start;;
  cqlsh)  exec bin/cqlsh cassandra 9042;;
  *)      exec $@;;
esac

