FROM alpine

ENV RETHINKDB_VERSION 2.3.6

ENV SERVER_NAME rethinkdb

ENV SERVER_TAG default

ENV WEBUI_PORT 28080

LABEL Description="RethinkDB ${RETHINKDB_VERSION} light server"
LABEL Usage="docker run -d --name=${SERVER_NAME} --network=udn -p 28015:28015 29015:29015 ${WEBUI_PORT}:${WEBUI_PORT} rethinkdb start"

RUN set -x && mkdir -p /data \
    && apk update && apk add --no-cache rethinkdb  \
    && chown -R rethinkdb /data 

USER rethinkdb

VOLUME /data

EXPOSE 28015 29015

EXPOSE ${WEBUI_PORT}

ENTRYPOINT exec rethinkdb --bind all -d /data -n ${SERVER_NAME} --http-port ${WEBUI_PORT} --server-tag ${SERVER_TAG} --no-update-check
