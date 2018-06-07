FROM alpine-jdk:8

ARG SITE_DOWNLOAD=http://artfiles.org/apache.org

ENV CASSANDRA_VERSION 3.11.2

# supported values: low, default, or a size
ENV HEAP low

# Server Name (required by CLI)
ENV SERVER_NAME cassandra

LABEL Description="Cassandra ${CASSANDRA_VERSION} server"
LABEL Usage="docker run -d --name=${SERVER_NAME} --network=udn -e HEAP=low --mount source=cassandra,target=/data -p 9042:9042 cassandra start "
LABEL Usage2="docker run -it --rm --network=udn cassandra cqlsh"

RUN set -x && apk update && apk add python \
    && mkdir -p /opt  \
    && curl -s ${SITE_DOWNLOAD}/cassandra/${CASSANDRA_VERSION}/apache-cassandra-${CASSANDRA_VERSION}-bin.tar.gz | tar xzf - -C /opt \ 
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

