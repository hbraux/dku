#!/bin/bash

function _help {
 echo "$IMAGE_INFO

Prerequisites:
1/ create a Used Defined Network for server Name resolution; example
     docker network create --driver bridge udn
2/ start Elastic container
3/ optionaly set environment Variables
  LOGSTASH_INPUT   : input plugin conf, 'tcp/json' by default
  LOGSTASH_OUTPUT  : output plugin conf, 'elasticsearch' by default
  LOGSTASH_FILTER  : filter plugin conf, none by default
  LOGSTASH_ESHOST  : elasticsearch host, 'elastic:9200' by default
  LOGSTASH_ESINDEX : elasticsearch index, 'logstash' by default

Start server
  docker run -d --name=logstash --network=udn logstash start

Start server in interactive mode (ruby shell)
  docker run -it --rm --network=udn logstash shell

Stop server
  docker stop logstash && docker rm logstash
"
}

function _setup {
  [[ -f .setup ]] && return

  LOGSTASH_ESINDEX=${LOGSTASH_ESINDEX:-logstash}
  LOGSTASH_ESHOST=${LOGSTASH_ESHOST:-http://elastic:9200}
  DEFAULT_INPUT="tcp { port => 5000 codec => json }"
  DEFAULT_OUTPUT="elasticsearch { hosts => [\"$LOGSTASH_ESHOST\"] index => \"$LOGSTASH_ESINDEX\" }"
  LOGSTASH_INPUT=${LOGSTASH_INPUT:-$DEFAULT_INPUT}
  LOGSTASH_OUTPUT=${LOGSTASH_OUTPUT:-$DEFAULT_OUTPUT}
  
  echo "input{ $LOGSTASH_INPUT }" >>data/logstash.conf
  [[ -n $LOGSTASH_FILTER ]] &&  echo "filter { $LOGSTASH_FILTER }" >>data/logstash.conf
  echo "output { $LOGSTASH_OUTPUT }" >>data/logstash.conf
  
  touch .setup
}
export -f _setup # debug

function _start {
  _setup
  exec logstash -f data/logstash.conf
}


case $1 in
  help)  _help;;
  start) _start;;
  shell)   exec bin/logstash -i irb;;
  *)       exec "$@"
esac

