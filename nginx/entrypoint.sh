#!/bin/sh

function _setup {
  [[ -f .setup ]] && return
  mkdir -p /data/files
  echo $DOCKER_HOST | egrep -q '^[a-z]*' 
  if [[ $? -ne 0 ]]; then
    echo "ERROR: DOCKER_HOST shall be a FQDN."
    exit 1
  fi
  DOCKER_DOMAIN=$(echo $DOCKER_HOST | sed 's/[a-z0-9]*\.//')
  sed -i "s/%DOCKER_DOMAIN%/${DOCKER_DOMAIN}/g" /etc/nginx/nginx.tmpl

  cat >/etc/nginx/conf.d/default.conf<<EOF
server {
  listen 80 default_server;
  listen [::]:80 default_server;
  root  /data;
  location / {
  }
  location /files/ {
    autoindex on;
  }
}
EOF

  cat>/data/index.html <<EOF
<html>
<body>
<b>NGINX HTTP cache and Reverse Proxy for docker services</b>
<br/>
<ul>
<li><a href="http://$DOCKER_HOST:80/files">HTTP download</a></li>
</ul>
</div>
</body>
</html>
EOF
  chown -R nginx:nginx /data
  touch .setup
}


function _start {
  nginx
  # unset DOCKER_HOST as it conflicts with /var/run/docker.sock
  unset DOCKER_HOST
  docker-gen -watch -notify "nginx -s reload" -only-published /etc/nginx/nginx.tmpl /etc/nginx/conf.d/default.conf 
}

_setup

case $1 in
  start) _start;;
  *)       exec $@;;
esac

