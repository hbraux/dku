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
ln -s $(pwd)/dku/bin/dku $HOME/bin/dku
dku
```

The default repository is the username. It can be orriden by setting varible IMAGE_REPO in the environment profile


## Image List

Name | Description
---- | ----
alpine-jdk   | alpine image with JDK
alpine-llvm  | alpine image with LLVM
nginx        | Nginx with Reverse Proxy and Static Files support
hbase        | HBase with Rest API 
elastic      | Elasticsearch 
cassandra    | Cassandra
mongodb      | MongoDB with Restheart API 
kafka        | Kafka server
rethinkdb    | RethinkDB 
logstash     | Logstash
nifi         | NiFi 1.7.1 slim server 



