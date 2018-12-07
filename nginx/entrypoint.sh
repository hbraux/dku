#!/bin/sh

function _setup {

  [[ -f $NGINX_CONF/.setup ]] && return
  mkdir -p /data/files/upload
  echo $HOST_HOSTNAME | egrep -q '^[a-z]*' 
  if [ $? -ne 0 ]; then
    echo "ERROR: HOST_HOSTNAME shall be a FQDN."
    exit 1
  fi
  tmpl=$NGINX_CONF/nginx_${URL_REDIRECTION}.tmpl
  if [ ! -f $tmpl ] ; then
    echo "ERROR: file $tmpl does not exist."
    exit 1
  fi
  cp $tmpl $NGINX_CONF/nginx.tmpl
  HOST_DOMAIN=$(echo $HOST_HOSTNAME | sed 's/[a-z0-9]*\.//')
  sed -i "s/%HOST_HOSTNAME%/${HOST_HOSTNAME}/g" $NGINX_CONF/nginx.tmpl
  sed -i "s/%HOST_DOMAIN%/${HOST_DOMAIN}/g" $NGINX_CONF/nginx.tmpl

  rm -fr $NGINX_CONF/conf.d && mkdir -p $NGINX_CONF/conf.d
  cat >$NGINX_CONF/conf.d/default.conf<<EOF
server {
  listen 80 default_server;
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
  touch $NGINX_CONF/.setup
}


_setup

function _start {
  _setup
  nginx 
  docker-gen -watch -notify "nginx -s reload" -only-published $NGINX_CONF/nginx.tmpl $NGINX_CONF/conf.d/default.conf 
}


case $1 in
  start) _start;;
  *)       exec $@;;
esac

