FROM alpine-jdk:8

ARG SITE_DOWNLOAD=http://apache.crihan.fr

# To reduce image size, the Nifi Archives are exluded by default
ARG EXCLUDE="*.nar"

# execept the Core archives and some Connectors that can be overriden at build time
ARG NIFI_CORE_NARS=framework,provenance-repository,jetty-bundle-1.5.0.nar,standard,standard-services-api,ssl-context-service,enrich,record-serialization-services,update-attribute,avro,kite
ARG NIFI_CONN_NARS=hbase,hbase_1_1_2-client-service,hadoop-libraries


ENV NIFI_VERSION 1.5.0
ENV NIFI_PORT 9090
ENV HEAP_SIZE 256m
ENV SERVER_NAME nifi

LABEL Description="Nifi ${NIFI_VERSION} light server"
LABEL Usage="docker run -d --name=${SERVER_NAME} -h nifi --mount source=nifi,target=/data -p ${NIFI_PORT}:${NIFI_PORT} nifi"

RUN set -x && mkdir -p /opt /data \
    && curl -s ${SITE_DOWNLOAD}/dist/nifi/${NIFI_VERSION}/nifi-${NIFI_VERSION}-bin.tar.gz | tar xzf - -C /opt \
    && mv /opt/nifi-${NIFI_VERSION} /opt/nifi \
    && cd /opt/nifi/lib && curl -s -O https://jdbc.postgresql.org/download/postgresql-42.2.4.jar \
    && adduser -D -s /sbin/nologin nifi \
    && chown -R nifi: /opt/nifi /data \
    # cleanup
    && rm -r /opt/nifi/docs \
    && set +x && for f in $(find /opt/nifi/lib -name ${EXCLUDE} | sort); do l=${f:19} ; echo "${NIFI_CORE_NARS},${NIFI_CONN_NARS}," | grep -q "${l%-nar*}," || rm -v $f ; done

COPY entrypoint.sh /

ENV PATH ${PATH}:/opt/nifi/bin
WORKDIR /opt/nifi

USER nifi

EXPOSE ${NIFI_PORT}

VOLUME /data

ENTRYPOINT ["/entrypoint.sh"]

CMD ["start"]


