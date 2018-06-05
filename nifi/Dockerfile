FROM alpine-jdk:8

ARG SITE_DOWNLOAD=http://apache.crihan.fr

# To reduce image size only keep the Nifi Archives that are mandatory (Core) or used (Connectors)
ARG NIFI_CORE_NARS=framework,provenance-repository,jetty-bundle-1.5.0.nar,standard,standard-services-api,ssl-context-service,enrich,record-serialization-services,update-attribute,avro,kite
ARG NIFI_CONN_NARS=hbase,hbase_1_1_2-client-service,hadoop-libraries



ENV NIFI_VERSION 1.5.0

ENV HEAP_SIZE 256m

LABEL Description="Nifi ${NIFI_VERSION} light server"
LABEL Usage="docker run -d --name=nifi -h nifi --network=udn -p 8080:8080 nifi start"

RUN set -x && mkdir -p /opt /data \
    && curl -s ${SITE_DOWNLOAD}/dist/nifi/${NIFI_VERSION}/nifi-${NIFI_VERSION}-bin.tar.gz | tar xzf - -C /opt \
    && mv /opt/nifi-${NIFI_VERSION} /opt/nifi \
    && adduser -D -s /sbin/nologin nifi \
    && chown -R nifi: /opt/nifi /data \
    # cleanup
    && rm -r /opt/nifi/docs \
    && set +x && for f in $(find /opt/nifi/lib -name "*.nar" | sort); do l=${f:19} ; echo "${NIFI_CORE_NARS},${NIFI_CONN_NARS}," | grep -q "${l%-nar*}," || rm -v $f ; done 

COPY entrypoint.sh /

ENV PATH ${PATH}:/opt/nifi/bin
WORKDIR /opt/nifi

USER nifi

EXPOSE 8080

VOLUME /data

ENTRYPOINT ["/entrypoint.sh"]

CMD ["help"]


