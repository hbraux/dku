ARG ALPINE_VERSION
FROM alpine:${ALPINE_VERSION:-3.8}

ARG IMAGE_REPO
ARG HTTP_MIRROR=https://artifacts.elastic.co
ARG USE_PROXY=on

ENV FILEBEAT_VERSION 5.6.13

LABEL description "Filebeat ${FILEBEAT_VERSION} server"
LABEL usage "docker run -d --name filebeat --network udn -v /var/lib/docker/containers:/var/lib/docker/containers:ro -v /var/run/docker.sock:/var/run/docker.sock:ro ${IMAGE_REPO:-local}/filebeat"

RUN mkdir -p /opt \
    && wget -Y ${USE_PROXY} -O - ${HTTP_MIRROR}/downloads/beats/filebeat/filebeat-${FILEBEAT_VERSION}-linux-x86_64.tar.gz | tar xzf - -C /opt \
    && mv /opt/filebeat-${FILEBEAT_VERSION}-linux-x86_64 /opt/filebeat \
    && rm -fr /opt/filebeat/scripts 

COPY entrypoint.sh /

WORKDIR /opt/filebeat

USER root


ENTRYPOINT ["/entrypoint.sh"]

CMD ["start"]


