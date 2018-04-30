# docker-light
A set of very slim docker images based on Alpine Linux. To be used for testing or development purpose only

All images are auto-descriptive. Just inspect the labels
```sh
docker inspect --format='{{range $k,$v:=.Config.Labels}}{{$k}}: {{println $v}}{{end}}' hbase
```

## Image List

* alpine-jdk : OpenJDK (80MB)
* hbase      : HBase 1.2.6 with Rest Server (162MB)
* 
