FROM alpine-jdk

ARG SITE_DOWNLOAD=https://artifacts.elastic.co

ENV ELASTICSEARCH_VERSION 5.6.6

# supported values: low, default, or a size
ENV HEAP low

ENV CLUSTER_NAME test

# Server Name and Port (used by reverse proxy to expose REST API)
ENV VIRTUAL_HOST elastic
ENV VIRTUAL_PORT 9200

LABEL Description "Elasticsearch ${ELASTICSEARCH_VERSION} standalone Server"
LABEL Usage "docker run -d --name=${VIRTUAL_HOST} --network=udn --mount source=elastic,target=/data -p ${VIRTUAL_PORT} elastic"


# Heap size
ENV HEAP 128m

RUN set -x && mkdir -p /opt /data \
    && curl -s ${SITE_DOWNLOAD}/downloads/elasticsearch/elasticsearch-${ELASTICSEARCH_VERSION}.tar.gz | tar xzf - -C /opt \ 
    && mv /opt/elasticsearch-${ELASTICSEARCH_VERSION} /opt/elasticsearch \
    && adduser -DH -s /sbin/nologin elastic \
    && chown -R elastic: /opt/elasticsearch /data

COPY entrypoint.sh /

ENV PATH ${PATH}:/opt/elasticsearch/bin
WORKDIR /opt/elasticsearch

USER elastic

# HTTP port
EXPOSE ${VIRTUAL_PORT}

VOLUME /data

ENTRYPOINT ["/entrypoint.sh"]

CMD ["start"]


