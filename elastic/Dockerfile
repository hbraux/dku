
ARG IMAGE_REPO
FROM ${IMAGE_REPO}/alpine-jdk:8

ARG IMAGE_REPO
ARG HTTP_MIRROR=https://artifacts.elastic.co
ARG DOCKER_DATADIR=/data
ARG UID=1000
ARG GID=1000

ENV ELASTICSEARCH_VERSION 5.6.6
ENV ELASTICSEARCH_HOME /opt/elasticsearch
ENV ELASTICSEARCH_CLUSTERNAME test
ENV PATH $PATH:$ELASTICSEARCH_HOME/bin

# supported values: low, default, or a size
ENV HEAP 256m


# Server Name and Port (used by reverse proxy to expose REST API)
ENV VIRTUAL_HOST elastic
ENV VIRTUAL_PORT 9200

LABEL description "Elasticsearch ${ELASTICSEARCH_VERSION} standalone Server"
LABEL usage "docker run -d --name ${VIRTUAL_HOST} --network udn -v ${DOCKER_DATADIR}/elastic:/data -p ${VIRTUAL_PORT} ${IMAGE_REPO:-local}/elastic"

RUN set -x && mkdir -p /opt /data \
    && curl -s ${HTTP_MIRROR}/downloads/elasticsearch/elasticsearch-${ELASTICSEARCH_VERSION}.tar.gz | tar xzf - -C /tmp \ 
    && mv /tmp/elasticsearch-${ELASTICSEARCH_VERSION} ${ELASTICSEARCH_HOME} \
    && addgroup -g $GID -S elastic \
    && adduser -u $UID -D -S -H -G elastic -h $ELASTICSEARCH_HOME elastic \
    && chown -R elastic:elastic ${ELASTICSEARCH_HOME} /data

COPY entrypoint.sh /

WORKDIR $ELASTICSEARCH_HOME

USER elastic

# HTTP port
EXPOSE ${VIRTUAL_PORT}

VOLUME /data

ENTRYPOINT ["/entrypoint.sh"]

CMD ["start"]


