ARG IMAGE_REPO
FROM ${IMAGE_REPO}/alpine-jdk:8

ARG IMAGE_REPO
ARG HTTP_MIRROR=http://apache.mirrors.ovh.net/ftp.apache.org

ENV KAFKA_VERSION 0.10.2.1 

ENV SCALA_VERSION 2.10 

# supported values: low, default, or a size
ENV HEAP low

ENV SERVER_NAME kafka

LABEL description "Kafka ${KAFKA_VERSION} standalone server"
LABEL usage "docker run -d --name=${SERVER_NAME} --network=udn --mount source=kafka,target=/data -p 2181:2181 -p 9092:9092 ${IMAGE_REPO:-local}/kafka start "
LABEL usage_cfgt "docker run -it --rm --network=udn ${IMAGE_REPO:-local}/kafka kafka-topics.sh --zookeeper kafka:2181 --create --topic mytopic --partitions 1 --replication-factor 1"
LABEL usage_cnsp "docker run -it --rm --network=udn ${IMAGE_REPO:-local}/kafka-console-producer.sh --broker-list kafka:9092 --topic mytopic"
LABEL usage_cnsc "docker run -it --rm --network=udn ${IMAGE_REPO:-local}/kafka kafka-console-consumer.sh --bootstrap-server kafka:9092 --topic mytopic [ --from-beginning ]"
LABEL usage_tool "docker run  -it --rm --network=udn ${IMAGE_REPO:-local}/kafka kafka-json.sh kafka:9092 mytopic .."

RUN set -x && mkdir -p /opt && mkdir -p /data  \
    && curl -s ${HTTP_MIRROR}/dist/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz | tar xzf - -C /opt \
    && mv /opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION} /opt/kafka \
    && rm -fr /opt/kafka/site-docs \
    && adduser -D -s /sbin/nologin kafka \
    && chown -R kafka: /opt/kafka /data

COPY entrypoint.sh /
COPY tools/* /opt/kafka/bin

ENV PATH ${PATH}:/opt/kafka/bin
WORKDIR /opt/kafka

USER kafka

# Zookeeper
EXPOSE 2181

# Kafka brokers
EXPOSE 9092

VOLUME /data

ENTRYPOINT ["/entrypoint.sh"]

CMD ["help"]


