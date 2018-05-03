# docker-light
A set of slim docker images based on Alpine Linux with low memoy requirements.
To be used for testing or development purpose, mostly on Virtualbox

All images are auto-descriptive. Just inspect the labels to get description and usage(s)
```sh
docker inspect --format='{{range $k,$v:=.Config.Labels}}{{$k}}: {{println $v}}{{end}}' hbase
```

## Image List

Name | Size | Description and RAM consumption
---- | ---- | ----
alpine-jdk   | 80MB  | base image with Open-JDK 8 and bash
alpine-glibc | 30MB  | base image with prerequisites for Conda installation
hbase        | 162MB | HBase 1.2.6 sdandalone with Rest Server (300MB)
elastic      | 116MB | Elasticsearch 5.6 standalone server (300MB)
mongodb      | 192MB | MongoDB 3.4.10 with Restheart (80 MB)
rethinkdb    | 50MB  | RethinkDB 2.3.6 
py2          | 287MB | Conda python2
py3          | 347MB | Conda python3
jupyter      | 2.3GB | Conda Jupyter Server with python2 and major datascience libs


## TODO list
* HBase support of Java Client; non verbose logs
* Mongo non verbose logs

