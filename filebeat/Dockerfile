ARG ALPINE_VERSION
FROM alpine:${ALPINE_VERSION:-3.8}

ARG IMAGE_REPO
ARG HTTP_MIRROR=https://artifacts.elastic.co

ENV FILEBEAT_VERSION 6.5.4

LABEL description "Filebeat ${FILEBEAT_VERSION} server"
LABEL usage "docker run -d --name filebeat --user root --network udn -v /var/lib/docker/containers:/var/lib/docker/containers:ro -v /var/run/docker.sock:/var/run/docker.sock:ro ${IMAGE_REPO:-local}/filebeat"

# filebeat-6-x needs libc6
RUN apk add --no-cache libc6-compat curl

RUN mkdir -p /opt /data \
    && curl -s ${HTTP_MIRROR}/downloads/beats/filebeat/filebeat-${FILEBEAT_VERSION}-linux-x86_64.tar.gz | tar xzf - -C /opt \
    && mv /opt/filebeat-${FILEBEAT_VERSION}-linux-x86_64 /opt/filebeat \
    && adduser -D -s /sbin/nologin beat \
    && chown -R beat:beat /opt/filebeat /data

COPY entrypoint.sh /
copy filebeat.yml /opt/filebeat

WORKDIR /opt/filebeat

USER beat

ENTRYPOINT ["/entrypoint.sh"]

CMD ["start"]


