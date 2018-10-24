# Limitations: JAVA API only supported on Docker's User Defined Network udn

ARG IMAGE_REPO
FROM ${IMAGE_REPO}/alpine-jdk:8

ARG IMAGE_REPO
ARG HTTP_MIRROR=http://apache.mirrors.ovh.net/ftp.apache.org

ENV FLINK_VERSION 1.6.1
ENV FLINK_BUILD hadoop27-scala_2.11

# supported values: low, default, or a size
ENV HEAP low

# Server Name and Port (used by reverse proxy to expose REST API)
ENV VIRTUAL_HOST flink
ENV VIRTUAL_PORT 8081

LABEL description "Flink ${FLINK_VERSION} standalone server"
LABEL usage "docker run -d --name=${VIRTUAL_HOST} --network=udn -e HEAP=low --mount source=flink,target=/data -p ${VIRTUAL_PORT} ${IMAGE_REPO:-local}/flink"

RUN set -x && mkdir -p /opt  \
    && curl -s ${HTTP_MIRROR}/dist/flink/flink-${FLINK_VERSION}/flink-${FLINK_VERSION}-bin-${FLINK_BUILD}.tgz | tar xzf - -C /opt \ 
    && mv /opt/flink-${FLINK_VERSION} /opt/flink \
    && rm -fr /opt/flink/docs /opt/flink/examples \
    && mkdir -p /opt/flink/logs /data \
    && adduser -DH -s /sbin/nologin flink \
    && chown -R flink: /opt/flink /data 

COPY entrypoint.sh /

WORKDIR /opt/flink

USER flink

# Rest API 
EXPOSE ${VIRTUAL_PORT}

# Master web UI 
EXPOSE 8081

VOLUME /data

ENTRYPOINT ["/entrypoint.sh"]

CMD ["start"]

