# JDK is needed for Restheart not for MongoDB

ARG IMAGE_REPO
FROM ${IMAGE_REPO}/alpine-jdk:8

ARG IMAGE_REPO
ARG HTTP_MIRROR=https://github.com/SoftInstigate

ENV MONGODB_VERSION 3.6.7

ENV RESTHEART_VERSION 3.2.2

# Server Name and Port (used by reverse proxy to expose REST API)
ENV VIRTUAL_HOST mongodb
ENV VIRTUAL_PORT 8080

LABEL description "MongoDB ${MONGODB_VERSION} server with RestHeart"
LABEL usage "docker run -d --name=${VIRTUAL_HOST} --network=udn -p ${VIRTUAL_PORT} ${IMAGE_REPO:-local}/mongodb"
LABEL usage_shell "docker run -it --rm --network=udn ${IMAGE_REPO:-local}/mongodb shell"

RUN set -x && mkdir -p /opt && mkdir -p /data/db \
    && apk add --no-cache mongodb \
    && curl -s ${HTTP_MIRROR}/restheart/releases/download/${RESTHEART_VERSION}/restheart-${RESTHEART_VERSION}.tar.gz | tar xzf - -C /opt \
    && mv /opt/restheart-${RESTHEART_VERSION} /opt/restheart \
    && chown -R mongodb /opt/restheart /data \
    # remove that big file
    && rm -f /usr/bin/mongoperf 

COPY entrypoint.sh /

USER mongodb

WORKDIR /opt/restheart

VOLUME /data

# Mongo DB Port
EXPOSE 27017

# Restheart API
EXPOSE ${VIRTUAL_PORT}

ENTRYPOINT [ "/entrypoint.sh" ]

CMD [ "start"]
