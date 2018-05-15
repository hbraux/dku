FROM alpine:3.7

ENV BIGCHAINDB_VERSION 2.0

ENV PYTHONUNBUFFERED 0

ENV SERVER_NAME bigchaindb


LABEL Description="BigchainDB ${BIGCHAINDB_VERSION} standalone server with MongoDB"
LABEL Usage="docker run -d --name=${SERVER_NAME} --network=udn --mount source=bigchaindb,target=/data -p 9984:9984 9985:9985 bigchaindb start"
LABEL Usage2="docker run -it --rm --network=udn bigchaindb mongo-shell"
LABEL Usage3="docker run -it --rm --network=udn bigchaindb python"

RUN set -x && mkdir -p /data/db /usr/src/app \
    && apk update && apk add --no-cache bash g++ make musl-dev python3 python3-dev libffi-dev libressl-dev mongodb \
    && python3 -m ensurepip && pip3 install --upgrade pip setuptools \
    && pip3 install bigchaindb_driver

ENV BIGCHAINDB_CONFIG_PATH /data/.bigchaindb
ENV BIGCHAINDB_SERVER_WORKERS 1

COPY entrypoint.sh /
COPY bigchaindb /usr/src/app/bigchaindb

WORKDIR /usr/src/app

EXPOSE 9984 9985

VOLUME /data

ENTRYPOINT [ "/entrypoint.sh" ]

CMD [ "start"]
