#!/bin/sh

function _setup {
  [[ -f .setup ]] && return

  touch .setup
}

#export -f _setup

function _start {
  _setup
  exec nginx  -g "daemon off;"

}


case $1 in
  start) _start;;
  *)       exec $@;;
esac

