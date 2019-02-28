ARG IMAGE_REPO
FROM ${IMAGE_REPO}/alpine-jdk:8

ARG IMAGE_REPO
ARG HTTP_MIRROR=https://archive.apache.org
ARG DOCKER_DATADIR=/data
ARG UID=1000
ARG GID=1000

ENV FLINK_VERSION 1.6.1
ENV FLINK_BUILD hadoop28-scala_2.11
ENV FLINK_HOME /opt/flink
ENV FLINK_JM_HEAP=256m
ENV FLINK_TM_HEAP=1024m

ENV PATH $PATH:$FLINK_HOME/bin

# Server Name and Port (used by reverse proxy to expose REST API)
ENV VIRTUAL_HOST flink
ENV VIRTUAL_PORT 8081

LABEL description "Flink ${FLINK_VERSION} standalone server"
LABEL usage "docker run -d --name=${VIRTUAL_HOST} --network=udn -v ${DOCKER_DATADIR}/flink:/data -p ${VIRTUAL_PORT} ${IMAGE_REPO:-local}/flink"

# adding libgomp for XGBoost 
RUN apk add --no-cache libgomp 

RUN set -x && mkdir -p /opt  /data \
    && curl -s ${HTTP_MIRROR}/dist/flink/flink-${FLINK_VERSION}/flink-${FLINK_VERSION}-bin-${FLINK_BUILD}.tgz | tar xzf - -C /tmp \ 
    && mv /tmp/flink-${FLINK_VERSION} $FLINK_HOME \
    && cp $FLINK_HOME/examples/streaming/WordCount.jar $FLINK_HOME \
    && addgroup -g $GID -S flink \
    && adduser -u $UID -D -S -H -G flink -h $FLINK_HOME flink \
    && chown -R flink:flink $FLINK_HOME /data 

COPY entrypoint.sh  $FLINK_HOME/bin

WORKDIR $FLINK_HOME

USER flink

EXPOSE ${VIRTUAL_PORT}

VOLUME /data

ENTRYPOINT ["/opt/flink/bin/entrypoint.sh"]

CMD ["start"]

