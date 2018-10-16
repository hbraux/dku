FROM dku/alpine-jdk:8


ARG HTTP_MIRROR=https://github.com/JanusGraph/janusgraph/releases/

ENV JANUSGRAPH_VERSION 0.3.1

# Server Name 
ENV SERVER_NAME janusgraph

LABEL Description="JanusGraph ${JANUSGRAPH_VERSION} server"
LABEL Usage="docker run -d --name=${SERVER_NAME} --network=udn -e HEAP=low --mount source=janusgraph,target=/data dku/janusgraph"

RUN set -x && apk add --no-cache python \
    && mkdir -p /opt  \
    && curl -s ${HTTP_MIRROR}/cassandra/${CASSANDRA_VERSION}/apache-cassandra-${CASSANDRA_VERSION}-bin.tar.gz | tar xzf - -C /opt \ 
    && mv /opt/janusgraph-${JANUSGRAPH_VERSION} /opt/janusgraph \
    && adduser -D -s /sbin/nologin janusgraph \
    && chown -R janusgraph: /opt/janusgraph /data

COPY entrypoint.sh /

WORKDIR /opt/janusgraph

USER janusgraph

VOLUME /data

EXPOSE 9042
       
ENTRYPOINT ["/entrypoint.sh"]

CMD ["start"]

