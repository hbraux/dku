# JDK is needed for Restheart not for MongoDB
FROM alpine-jdk

ARG SITE_DOWNLOAD=https://github.com/SoftInstigate

ENV MONGODB_VERSION 3.4.10

ENV RESTHEART_VERSION 3.2.2

# Server Name and Port (used by reverse proxy to expose REST API)
ENV VIRTUAL_HOST mongodb
ENV VIRTUAL_PORT 8080

LABEL Description="MongoDB ${MONGODB_VERSION} light server with RestHeart"
LABEL Usage="docker run -d --name=${VIRTUAL_HOST} --network=udn -p ${VIRTUAL_PORT} mongodb"
LABEL Usage2="docker run -it --rm --network=udn mongodb shell"

RUN set -x && mkdir -p /opt && mkdir -p /data/db \
    && apk add --no-cache mongodb \
    && curl -s ${SITE_DOWNLOAD}/restheart/releases/download/${RESTHEART_VERSION}/restheart-${RESTHEART_VERSION}.tar.gz | tar xzf - -C /opt \
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
