FROM alpine-jdk:8

ARG URL_DOWNLOAD=http://apache.crihan.fr

ENV HBASE_VERSION 1.2.6

# supported values: low, default, or a size
ENV HEAP low

# Server Name (required by CLI)
ENV SERVER_NAME hbase

# Rest API Port
ENV REST_PORT 16000

LABEL Description="HBase ${HBASE_VERSION} light server with Rest API"
LABEL Usage="docker run -d --name=${SERVER_NAME} --network=udn -e HEAP=low --mount source=hbase,target=/data -p ${REST_PORT}:${REST_PORT} -p 16010:16010 hbase start "
LABEL Usage2="docker run -it --rm --network=udn hbase shell"

RUN set -x && mkdir -p /opt  \
    && curl -s ${URL_DOWNLOAD}/dist/hbase/${HBASE_VERSION}/hbase-${HBASE_VERSION}-bin.tar.gz | tar xzf - -C /opt \ 
    && mv /opt/hbase-${HBASE_VERSION} /opt/hbase \
    && rm -fr /opt/hbase/docs \
    && mkdir -p /opt/hbase/logs /data \
    && adduser -DH -s /sbin/nologin hbase \
    && chown -R hbase: /opt/hbase /data

COPY entrypoint.sh /

WORKDIR /opt/hbase

USER hbase

# Zookeeper (needed for hbase shell)
EXPOSE 2181

# Rest API (changeable)
EXPOSE ${REST_PORT}

# Master web UI 
EXPOSE 16010

VOLUME /data

ENTRYPOINT ["/entrypoint.sh"]

CMD ["start"]


