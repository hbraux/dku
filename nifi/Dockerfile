ARG IMAGE_REPO
FROM ${IMAGE_REPO}/alpine-jdk:8

ARG IMAGE_REPO
ARG HTTP_MIRROR=http://apache.mirrors.ovh.net/ftp.apache.org

# To reduce image size the Nifi Archives are exluded by default (override to bypass exclusion)
ARG NIFI_EXCLUDES="*.nar"
# except the core Nars
ARG NIFI_CORE_INCLUDES=framework,provenance-repository,jetty-bundle-1.7.1.nar,standard,standard-services-api,ssl-context-service,enrich,record-serialization-services,update-attribute,avro,kite
# and those ones
ARG NIFI_EXTRA_INCLUDES=hadoop,hadoop-libraries,hbase,hbase_1_1_2-client-service

# additional drivers can be uploaded to the image for instance https://jdbc.postgresql.org/download/postgresql-42.2.4.jar
ARG DRIVERS="none"

ENV NIFI_VERSION 1.7.1
ENV HEAP_SIZE 256m

# Server Name and Port (used by reverse proxy to expose API)
ENV VIRTUAL_HOST nifi
ENV VIRTUAL_PORT 8080


LABEL description "Nifi ${NIFI_VERSION} slim server"
LABEL usage "docker run -d --name=${VIRTUAL_HOST} --network=udn --mount source=nifi,target=/data -p ${VIRTUAL_PORT} ${IMAGE_REPO:-local}/nifi"

RUN set -x && mkdir -p /opt /data \
    && curl -s ${HTTP_MIRROR}/dist/nifi/${NIFI_VERSION}/nifi-${NIFI_VERSION}-bin.tar.gz | tar xzf - -C /opt \
    && mv /opt/nifi-${NIFI_VERSION} /opt/nifi  \
    && adduser -D -s /sbin/nologin nifi \
    && chown -R nifi: /opt/nifi /data \
    # do some cleanup
    && rm -r /opt/nifi/docs  \
    && set +x && for f in $(find /opt/nifi/lib -name ${NIFI_EXCLUDES} | sort); do l=${f:19} ; echo "${NIFI_CORE_INCLUDES},${NIFI_EXTRA_INCLUDES}," | grep -q "${l%-nar*}," || rm -v $f ; done

COPY entrypoint.sh /

ENV PATH ${PATH}:/opt/nifi/bin
WORKDIR /opt/nifi

USER nifi

EXPOSE ${VIRTUAL_PORT}

VOLUME /data

ENTRYPOINT ["/entrypoint.sh"]

CMD ["start"]


