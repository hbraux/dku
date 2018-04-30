#!/bin/bash

function _setup {
  [[ -f .setup ]] && return
  (cat>etc/rest.yml)<<EOF
http-listener: true
http-port: ${REST_PORT}
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
  exec mongod 
}

case $1 in
  start)  _start;;
  shell)  exec mongo --host ${SERVER_NAME};;
  *)      exec $@;;
esac


