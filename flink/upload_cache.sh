#!/bin/bash

if [[ $# -eq 0 ]]
then echo "$0 <path>"; exit
fi

tmpfile=/tmp/fill_cache$$
path=$1

set -e -x
echo "ls CACHE/$path " | sftp 192.168.56.1  >$tmpfile 
file=$(tail -1 $tmpfile)
file=${file##*/}
rm -f $tmpfile
docker exec nginx mkdir -p /data/files/$path 
echo "Downloading $file"
sftp $USER@win.hostonly.com:CACHE/$path/$file $file
echo "Copying $file to container"
docker cp $file nginx:/data/files/$path/$file
rm -f $file 

curl -L http://$DOCKER_HOST/files/$path/



