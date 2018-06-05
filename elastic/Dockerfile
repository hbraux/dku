FROM alpine-jdk

ARG SITE_DOWNLOAD=https://artifacts.elastic.co

ENV ELASTICSEARCH_VERSION 5.6.6

ENV CLUSTER_NAME test

LABEL Description Elasticsearch ${ELASTICSEARCH_VERSION} light Server 
LABEL Usage "Docker run -d --name=elastic-server --network=udn --mount source=elastic,target=/data -p 9200:9200 -p 9300:9300 elasticstart"


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

EXPOSE 9200 9300

VOLUME /data

ENTRYPOINT ["/entrypoint.sh"]

CMD ["help"]


