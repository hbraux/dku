# docker-light
A set of slim docker images based on Alpine Linux with low memoy requirements.
To be used for testing or development purpose, on a Virtualbox VM .

All images are auto-descriptive. Just inspect the labels to get description
and usage(s) :
```sh
docker inspect --format='{{range $k,$v:=.Config.Labels}}{{$k}}: {{println $v}}{{end}}' hbase
```

The included script `docker-util.sh` provides somes helpers to build, run and
maange Docker images (make an alias on it)


## Image List

Name | Size | Description and RAM consumption
---- | ---- | ----
alpine-jdk   | 80MB  | base image with Open-JDK 8 and bash
alpine-glibc | 30MB  | base image with prerequisites for Conda installation
hbase        | 162MB | HBase 1.2.6 standalone server with Rest API (300MB)
kafka        | 118MB | Kafka 0.10 standalone server (250MB)
spark        | 310MB | Spark 1.6.0 standalone server 
elastic      | 116MB | Elasticsearch 5.6 standalone server (300MB)
mongodb      | 192MB | MongoDB 3.4.10 with Restheart (80 MB)
rethinkdb    | 50MB  | RethinkDB 2.3.6 (20MB)
jupyter      | 2.3GB | Conda Jupyter Server with main datascience libs
nifi         | 350MB | NiFi 1.5.0 slim server
bigchaindb   | 420MB | BigchainDB

## TODO list
* HBase support of Java Client (issue of dynamic ports)





