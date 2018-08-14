#!/bin/sh

function _setup {
  [[ -f .setup ]] && return
  sed -i "s/%DOMAIN%/${DOMAIN}/g" /etc/nginx/nginx.tmpl
  touch .setup
}


function _start {
  nginx
  docker-gen -watch -notify "nginx -s reload" -only-published /etc/nginx/nginx.tmpl /etc/nginx/conf.d/default.conf 
}

_setup

case $1 in
  start) _start;;
  *)       exec $@;;
esac

