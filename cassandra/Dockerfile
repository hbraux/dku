ARG IMAGE_REPO
FROM ${IMAGE_REPO}/alpine-jdk:8

ARG IMAGE_REPO
ARG HTTP_MIRROR=http://artfiles.org/apache.org

ENV CASSANDRA_VERSION 3.11.2

# supported values: low, default, or a size
ENV HEAP low

# Server Name (required by CLI)
ENV SERVER_NAME cassandra

LABEL description "Cassandra ${CASSANDRA_VERSION} server"
LABEL usage "docker run -d --name=${SERVER_NAME} --network=udn -e HEAP=low --mount source=cassandra,target=/data -p 9042:9042 ${IMAGE_REPO:-local}/cassandra"
LABEL usage_shell "docker run -it --rm --network=udn ${IMAGE_REPO:-local}/cassandra cqlsh"

RUN set -x && apk add --no-cache python \
    && mkdir -p /opt  \
    && curl -s ${HTTP_MIRROR}/cassandra/${CASSANDRA_VERSION}/apache-cassandra-${CASSANDRA_VERSION}-bin.tar.gz | tar xzf - -C /opt \ 
    && mv /opt/apache-cassandra-${CASSANDRA_VERSION} /opt/cassandra \
    && mkdir -p /opt/cassandra/logs /data \
    && adduser -D -s /sbin/nologin cassandra \
    && rm -fr /opt/cassandra/doc /opt/cassandra/javadoc \
    && chown -R cassandra: /opt/cassandra /data

COPY entrypoint.sh /

WORKDIR /opt/cassandra

USER cassandra

VOLUME /data

EXPOSE 9042
       
ENTRYPOINT ["/entrypoint.sh"]

CMD ["start"]

