#!/bin/bash


function _setup {
  [[ -f .setup ]] && return

  cfgfile=data/logstash.conf
  echo "input{ $LOGSTASH_PLUGIN }" >>$cfgfile
  [[ -n $LOGSTASH_FILTER ]] && echo "filter { $LOGSTASH_FILTER }" >>$cfgfile
  echo "output { elasticsearch { hosts => [\"$LOGSTASH_TARGET\"] index => \"$LOGSTASH_INDEX\" }}" >>$cfgfile

  [[ $HEAP == low ]] && HEAPSIZE=128m
  egrep -q '[0-9]+[kmg]'<<<$HEAP && HEAPSIZE=$HEAP
  [[ -n $HEAPSIZE ]] && sed -i "s/-Xms.*/-Xms$HEAPSIZE/;s/-Xmx.*/-Xmx$HEAPSIZE/" config/jvm.options

  touch .setup
}

function _start {
  _setup
  exec logstash -f data/logstash.conf --http.host $(hostname -i)
}

export -f _setup _start

case $1 in
  start) _start;;
  shell)   exec bin/logstash -i irb;;
  *)       exec "$@"
esac

