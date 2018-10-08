# dku
A wrapper for Docker plus a set of "slim" docker images (based on Alpine Linux and with low memory requirements)
To be used for testing or development purpose, for instance on a Virtualbox VM

The images do NOT support services and docker-compose. They are designed to run in standalone mode

All images are auto-descriptive. Just inspect the labels to get description and usage(s):
```sh
docker inspect --format='{{range $k,$v:=.Config.Labels}}{{$k}}: {{println $v}}{{end}}' hbase
```

The included script `docker-util.sh` provides somes helpers to build, run, test
and manage Docker images (alias dku=".../docker-util.sh")


## Image List

Name | Size | Description and RAM consumption
---- | ---- | ----
alpine-jdk   | 80MB  | base alpine image with Open-JDK 8 and bash
rproxy       | 17MB  | a Reverse Proxy Server based on Nginx and docker-gen 
hbase        | 162MB | HBase 1.2.6 standalone server with Rest API (300MB)
kafka        | 118MB | Kafka 0.10 standalone server (250MB)
spark        | 310MB | Spark 1.6.0 standalone server 
elastic      | 116MB | Elasticsearch 5.6 standalone server (300MB)
logstash     | 270MB | Logstash 5.6 server
mongodb      | 192MB | MongoDB 3.4.10 with Restheart (80 MB)
rethinkdb    | 50MB  | RethinkDB 2.3.6 (20MB)
nifi         | 360MB | NiFi 1.7.1 slim server 
cassandra    | 155MB | Cassandra 3.11.2 server (300MB)
systemd      | 270MB | CentOS 7 container with systemd  and sshd (user ansible)
bigchaindb   | 470MB | BigchainDB standalone server incl. MongoDB and Tendermint
jupyter      | 430MB | A Jupyter Server with ML libs 

## TODO list
* HBase support of Java Client (issue of dynamic ports)

