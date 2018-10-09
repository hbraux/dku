FROM alpine

ENV RETHINKDB_VERSION 2.3.6

ENV SERVER_TAG default

# Server Name and Port (used by reverse proxy to expose Web UI)
ENV VIRTUAL_HOST rethinkdb
ENV VIRTUAL_PORT 8080

LABEL Description="RethinkDB ${RETHINKDB_VERSION} light server"
LABEL Usage="docker run -d --name=${VIRTUAL_HOST} --network=udn -p 28015 -p 29015 -p ${VIRTUAL_PORT} rethinkdb"

RUN set -x && mkdir -p /data \
    && apk update && apk add --no-cache rethinkdb  \
    && chown -R rethinkdb /data 

USER rethinkdb

VOLUME /data

EXPOSE 28015 29015

EXPOSE ${VIRTUAL_PORT}

ENTRYPOINT exec rethinkdb --bind all -d /data -n ${VIRTUAL_HOST} --http-port ${VIRTUAL_PORT} --server-tag ${SERVER_TAG} --no-update-check
