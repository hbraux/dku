ARG IMAGE_REPO
FROM ${IMAGE_REPO}/alpine-jdk:8

ARG IMAGE_REPO
ARG HTTP_MIRROR=http://apache.mirrors.ovh.net/ftp.apache.org

ENV KAFKA_VERSION 1.1.1

ENV SCALA_VERSION 2.12

# supported values: low, default, or a size
ENV HEAP low

ENV SERVER_NAME kafka

LABEL description "Kafka ${KAFKA_VERSION} standalone server"
LABEL usage "docker run -d --name=${SERVER_NAME} --network=udn -e HEAP=low --mount source=kafka,target=/data -p 2181:2181 -p 9092:9092 ${IMAGE_REPO:-local}/kafka start "
LABEL usage_newtopic "docker run -it --rm --network=udn ${IMAGE_REPO:-local}/kafka kafka-topics.sh --zookeeper kafka:2181 --create --topic mytopic --partitions 1 --replication-factor 1"
LABEL usage_consolep "docker run -it --rm --network=udn ${IMAGE_REPO:-local}/kafka kafka-console-producer.sh --broker-list kafka:9092 --topic mytopic"
LABEL usage_consolec "docker run -it --rm --network=udn ${IMAGE_REPO:-local}/kafka kafka-console-consumer.sh --bootstrap-server kafka:9092 --topic mytopic --from-beginning"
LABEL usage_jsonmsg "docker run  -it --rm --network=udn ${IMAGE_REPO:-local}/kafka kafka-json.py kafka:9092 mytopic 10 '{\"uuid\":\"%UUID\",\"pkey\":\"%STR3\",\"skey\":\"%STR4\",\"value\":%INT99999}'"

RUN set -x && mkdir -p /opt && mkdir -p /data  \
    && curl -s ${HTTP_MIRROR}/dist/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz | tar xzf - -C /opt \
    && mv /opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION} /opt/kafka \
    && rm -fr /opt/kafka/site-docs \
    && adduser -D -s /sbin/nologin kafka \
    && chown -R kafka: /opt/kafka /data

# add python3 and kafka-kafka 
RUN apk add --no-cache python3 && ln -fs /usr/bin/python3 /usr/bin/python && pip3 install kafka-python

COPY entrypoint.sh /
COPY tools/* /opt/kafka/bin/

ENV PATH ${PATH}:/opt/kafka/bin
WORKDIR /opt/kafka

USER kafka

# Zookeeper
EXPOSE 2181

# Kafka brokers
EXPOSE 9092

VOLUME /data

ENTRYPOINT ["/entrypoint.sh"]

CMD ["start"]


