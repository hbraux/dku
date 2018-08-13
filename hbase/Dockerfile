FROM alpine-jdk:8

ARG SITE_DOWNLOAD=http://apache.crihan.fr

ENV HBASE_VERSION 1.2.6

# supported values: low, default, or a size
ENV HEAP low

# Server Name (required by CLI)
ENV VIRTUAL_HOST hbase

LABEL Description="HBase ${HBASE_VERSION} light server with Rest API"
LABEL Usage="docker run -d --name=${VIRTUAL_HOST} --network=udn -e HEAP=low --mount source=hbase,target=/data  -p 8080 hbase"
LABEL Usage2="docker run -it --rm --network=udn hbase shell"
LABEL Warnings="JAVA API only supported on Docker's User Defined Network udn"

RUN set -x && mkdir -p /opt  \
    && curl -s ${SITE_DOWNLOAD}/dist/hbase/${HBASE_VERSION}/hbase-${HBASE_VERSION}-bin.tar.gz | tar xzf - -C /opt \ 
    && mv /opt/hbase-${HBASE_VERSION} /opt/hbase \
    && rm -fr /opt/hbase/docs \
    && mkdir -p /opt/hbase/logs /data \
    && adduser -DH -s /sbin/nologin hbase \
    && chown -R hbase: /opt/hbase /data

COPY entrypoint.sh /

WORKDIR /opt/hbase

USER hbase

# Rest API 
EXPOSE 8080

# Zookeeper 
EXPOSE 2181

# Master web UI 
EXPOSE 16010

VOLUME /data

ENTRYPOINT ["/entrypoint.sh"]

CMD ["start"]

