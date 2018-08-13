#!/bin/sh

function _setup {
  [[ -f .setup ]] && return
  HOST_ADDRESS=$(/sbin/ip route|awk '/default/ { print $3 }')
  DOCKER_HOST=${DOCKER_HOST:-$HOST_ADDRESS}

  # http://vsftpd.beasts.org/vsftpd_conf.html
  cat <<EOF >>/etc/vsftpd/vsftpd.conf
idle_session_timeout=60
write_enable=YES
anon_root=/data
anon_mkdir_write_enable=YES
anon_other_write_enable=YES
anon_upload_enable=YES
anon_umask=0000
no_anon_password=YES
seccomp_sandbox=NO
pasv_enable=YES
pasv_min_port=${PASV_MIN_PORT}
pasv_max_port=${PASV_MAX_PORT}
pasv_address=${DOCKER_HOST}
ftpd_banner=Welcome to HTTP/FTP cache server. You can upload your file here
EOF
  # create pub directory
  mkdir -p /data/pub
  chmod 777 /data/pub

  sed -i "s~listen *80 default_server;~listen ${HTTP_PORT} default_server;\n root /data;\nautoindex on;~" /etc/nginx/conf.d/default.conf
  sed -i "s~return 404;~~" /etc/nginx/conf.d/default.conf
cat<<EOF>/data/index.html
<html>
<body>
<b>HTTP/FTP cache server with anonymous upload</b>
<br/>
<ul>
<li><a href="http://$DOCKER_HOST:$HTTP_PORT/pub">HTTP download</a></li>
<li><a href="ftp://$DOCKER_HOST/pub">FTP download/upload</a></li>
</ul>
</div>
</body>
</html>
EOF
  mkdir -p /run/nginx && chown 777 /run/nginx
  touch .setup
}


function _start {
  vsftpd /etc/vsftpd/vsftpd.conf &
  exec nginx  -g 'daemon off;'
}

_setup

case $1 in
  start) _start;;
  *)       exec $@;;
esac

