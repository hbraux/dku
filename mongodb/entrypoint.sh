#!/bin/bash

function _setup {
  [[ -f .setup ]] && return
  (cat>etc/rest.yml)<<EOF
http-listener: true
http-port: ${VIRTUAL_PORT}
https-listener: false
connection-options:
    MAX_HEADER_SIZE: 104857
EOF
  touch .setup
}
export -f _setup

function _start {
  _setup
  java -Dfile.encoding=UTF-8 -server -jar restheart.jar etc/rest.yml --fork
  exec mongod --smallfiles --oplogSize 128 --bind_ip_all
}

case $1 in
  start)  _start;;
  shell)  exec mongo --host ${VIRTUAL_HOST};;
  *)      exec $@;;
esac


