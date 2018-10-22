# dku : DocKer Utility

A wrapper for Docker and a set of slim docker images (based on Alpine Linux)
To be used for testing or development purpose, for instance on a VM

The images do NOT support services and docker-compose. They are designed to
run in standalone mode.

All images are auto-descriptive. Just inspect the labels to get description and usage(s), example:
```sh
docker inspect --format='{{range $k,$v:=.Config.Labels}}{{$k}}: {{println $v}}{{end}}' ${USER}/hbase
```

 
## Installation 

From non root user:
```
git clone THIS_REPO 
ln -s $(pwd)/dku/bin/dku $HOME/in/dku
dku
```

The default repository is the username. It can be orriden by setting varible IMAGE_REPO in the environment profile


## Image List

Name | Size | Description
---- | ---- | ----
alpine-jdk   | 80MB  | alpine image with JDK
alpine-llvm  | 80MB  | alpine image with LLVM

nginx        | 18MB  | Nginx with Reverse Proxy and Static Files support
hbase        | 165MB | HBase with Rest API 
elastic      | 120MB | Elasticsearch
cassandra    | 155MB | Cassandra
mongodb      | 200MB | MongoDB with Restheart API 
kafka        | 120MB | Kafka server
rethinkdb    | 50MB  | RethinkDB 

logstash     | 270MB | Logstash 5.6 server
nifi         | 360MB | NiFi 1.7.1 slim server 
jupyter      | 430MB | A Jupyter Server with ML libs 

## TODO list
* HBase support of Java Client (issue of dynamic ports)

