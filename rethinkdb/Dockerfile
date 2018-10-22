ARG ALPINE_VERSION
FROM alpine:${ALPINE_VERSION:-3.8}

ARG IMAGE_REPO

ENV RETHINKDB_VERSION 2.3.6
ENV SERVER_TAG default

# Server Name and Port (used by reverse proxy to expose Web UI)
ENV VIRTUAL_HOST rethinkdb
ENV VIRTUAL_PORT 8080

LABEL description "RethinkDB ${RETHINKDB_VERSION} light server"
LABEL usage "docker run -d --name=${VIRTUAL_HOST} --network=udn -p 28015:28015 -p 29015 -p ${VIRTUAL_PORT} ${IMAGE_REPO:-local}/rethinkdb"

RUN set -x && mkdir -p /data \
    && apk update && apk add --no-cache rethinkdb  \
    && chown -R rethinkdb /data 

USER rethinkdb

VOLUME /data

EXPOSE 28015 29015

EXPOSE ${VIRTUAL_PORT}

ENTRYPOINT exec rethinkdb --bind all -d /data -n ${VIRTUAL_HOST} --http-port ${VIRTUAL_PORT} --server-tag ${SERVER_TAG} --no-update-check
