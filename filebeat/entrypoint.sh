#!/bin/sh

function _setup {
  [[ -f .setup ]] && return

  touch .setup
}

function _start {
  _setup
  exec /opt/filebeat/filebeat  -E output.elasticsearch.hosts=elastic
}


case $1 in
  start) _start;;
  *)       exec $@;;
esac

