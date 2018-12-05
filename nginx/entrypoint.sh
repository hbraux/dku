#!/bin/sh

function _setup {
  [[ -f .setup ]] && return
  mkdir -p /data/files
  echo $HOST_HOSTNAME | egrep -q '^[a-z]*' 
  if [ $? -ne 0 ]; then
    echo "ERROR: HOST_HOSTNAME shall be a FQDN."
    exit 1
  fi
  tmpl=/etc/nginx/nginx_${URL_REDIRECTION}.tmpl
  if [ ! -f $tmpl ] ; then
    echo "ERROR: file $tmpl does not exist."
    exit 1
  fi
  ln -fs $tmpl /etc/nginx/nginx.tmpl
  HOST_DOMAIN=$(echo $HOST_HOSTNAME | sed 's/[a-z0-9]*\.//')
  sed -i "s/%HOST_HOSTNAME%/${HOST_HOSTNAME}/g" /etc/nginx/nginx.tmpl
  sed -i "s/%HOST_DOMAIN%/${HOST_DOMAIN}/g" /etc/nginx/nginx.tmpl

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
<b>NGINX HTTP cache + Reverse Proxy for docker services running on $HOST_HOSTNAME</b>
<br/>
<ul>
<li><a href="http://$HOST_HOSTNAME/files/">HTTP download</a></li>
<li><a href="http://$HOST_HOSTNAME/hbase/">HBase</a></li>
<li><a href="http://$HOST_HOSTNAME/elastic/">Elasticsearch</a></li>
<li><a href="http://$HOST_HOSTNAME/flink/">Flink</a></li>
<li><a href="http://$HOST_HOSTNAME/rethinkdb/">RethinkDB</a></li>
<li><a href="http://$HOST_HOSTNAME/nifi/nifi/">NIFI</a></li>
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
  docker-gen -watch -notify "nginx -s reload" -only-published /etc/nginx/nginx.tmpl /etc/nginx/conf.d/default.conf 
}

_setup

case $1 in
  start) _start;;
  *)       exec $@;;
esac

