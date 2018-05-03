#!/bin/bash

function _setup {
  [[ -f .setup ]] && return

  export BIGCHAINDB_SERVER_BIND=0.0.0.0:9984
  export BIGCHAINDB_WSSERVER_HOST=0.0.0.0
  export BIGCHAINDB_WSSERVER_ADVERTISED_HOST=0.0.0.0 
  bigchaindb -y configure  mongodb
  touch .setup
}

function _start {
  _setup
  mongod --replSet bigchain-rs  --smallfiles --oplogSize 128 &
  exec bigchaindb start
}

case $1 in
  start)  _start;;
  shell)  exec mongo --host ${SERVER_NAME};;
  *)      exec $@;;
esac


