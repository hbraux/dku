FROM jdk:8

ARG URL_DOWNLOAD=http://apache.crihan.fr

ENV HBASE_VERSION 1.2.6

# supported profiles: slim, default, or a Heap Size
ENV DOCKER_PROFILE default

LABEL Description="HBase ${HBASE_VERSION} server with Rest API"

LABEL Usage="docker run -d --name=hbase -e profile=slim --network=udn --mount source=hbase,target=/data -p 16000:16000 -p 16010:16010 hbase start "
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

# Rest API
EXPOSE 16000

# Master web UI 
EXPOSE 16010

VOLUME /data

ENTRYPOINT ["/entrypoint.sh"]

CMD ["start"]


