# Limitations: JAVA API only supported on Docker's User Defined Network udn

ARG IMAGE_REPO
FROM ${IMAGE_REPO}/alpine-jdk:8

ARG IMAGE_REPO
ARG HTTP_MIRROR=http://apache.mirrors.ovh.net/ftp.apache.org

ENV HBASE_VERSION 1.2.7

# supported Heap values: low, default, or a size
ENV HEAP low

# Server Name and Port (used by reverse proxy to expose REST API)
ENV VIRTUAL_HOST hbase
ENV VIRTUAL_PORT 8080

LABEL description "HBase ${HBASE_VERSION} standalone server with Rest API"
LABEL usage "docker run -d --name ${VIRTUAL_HOST} --network udn --label logging=filebeat -e HEAP=$HEAP -v hbase:/data -p ${VIRTUAL_PORT} ${IMAGE_REPO:-local}/hbase"
LABEL usage_shell "docker run -it --rm --network udn ${IMAGE_REPO:-local}/hbase shell"

RUN set -x && mkdir -p /opt /data \
    && curl -s ${HTTP_MIRROR}/dist/hbase/${HBASE_VERSION}/hbase-${HBASE_VERSION}-bin.tar.gz | tar xzf - -C /opt \ 
    && mv /opt/hbase-${HBASE_VERSION} /opt/hbase \
    && mkdir /opt/hbase/logs \
    && adduser -DH -s /sbin/nologin hbase \
    && chown -R hbase: /opt/hbase /data 

COPY entrypoint.sh /

WORKDIR /opt/hbase

USER hbase

# Rest API 
EXPOSE ${VIRTUAL_PORT}

# Zookeeper 
EXPOSE 2181

# Master web UI 
EXPOSE 16010

VOLUME /data

ENTRYPOINT ["/entrypoint.sh"]

CMD ["start"]

