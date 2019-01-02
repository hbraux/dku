#!/bin/sh

function _setup {
  [[ -f .setup ]] && return

  touch .setup
}

function _start {
  # _setup
  exec ./filebeat -e -d autodiscover,docker
}


case $1 in
  start) _start;;
  *)       exec $@;;
esac

