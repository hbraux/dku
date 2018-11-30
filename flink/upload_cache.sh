#!/bin/bash

# this should be added in /etc/hosts by VM deploy.sh
HOST=host

if [[ $# -eq 0 ]]
then echo "$0 <path>"; exit
fi

tmpfile=/tmp/fill_cache$$
path=$1

set -e -x
echo "ls CACHE/$path " | sftp $HOST  >$tmpfile 
file=$(tail -1 $tmpfile)
file=${file##*/}
rm -f $tmpfile
docker exec nginx mkdir -p /data/files/$path 
echo "Downloading $file"
sftp $USER@$HOST:CACHE/$path/$file $file
echo "Copying $file to container"
docker cp $file nginx:/data/files/$path/$file
rm -f $file 

curl -L http://$HOSTNAME/files/$path/



