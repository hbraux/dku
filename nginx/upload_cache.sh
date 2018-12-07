#!/bin/bash

# host should be in /etc/hosts (VM deploy.sh)
HOST=host

if [[ $# -eq 0 ]]; then 
  echo "$0 <path>"; exit
fi
path=$1

id=$(docker ps -q -f name=nginx)
if [[ -z $id ]]; then
  echo "nginx container is not running"; exit 1
fi
  

tmpfile=/tmp/fill_cache$$


set -e
echo "ls CACHE/$path " | sftp $HOST  >$tmpfile 
file=$(tail -1 $tmpfile)
file=${file##*/}
rm -f $tmpfile
echo "Downloading $file"
sftp $USER@$HOST:CACHE/$path/$file $file

if [[ -d $HOME/cache/files ]]; then
  echo "Copying file to $HOME/cache"
  mkdir -p $HOME/cache/files/$path
  mv $file $HOME/cache/files/$path/
else
  docker exec nginx mkdir -p /data/files/$path 
  echo "Copying $file to container"
  docker cp $file nginx:/data/files/$path/$file
  rm -f $file 
fi

echo "Checking URL"
curl -L http://$HOSTNAME/files/$path/



