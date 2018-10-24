FROM alpine-jdk

ARG SITE_DOWNLOAD=http://artifacts.elastic.co

ENV LOGSTASH_VERSION 5.6.6

# supported values: low, default, or a size
ENV HEAP low

# Logstash configuration can be overriden by those variables
ENV LOGSTASH_INDEX logstash
ENV LOGSTASH_TARGET http://elastic:9200
ENV LOGSTASH_PORT 5000
ENV LOGSTASH_PLUGIN "tcp { port => 5000 codec => json }"
ENV LOGSTASH_FILTER ""

LABEL Description "Logstash ${LOGSTASH_VERSION} Server"
LABEL Usage "docker run -d --name=logstash --network=udn -p ${LOGSTASH_PORT}:${LOGSTASH_PORT} logstash start"
LABEL Usage2 "docker run -it --rm --network=udn logstash shell"

RUN set -x && mkdir -p /opt \
    && curl -s ${SITE_DOWNLOAD}/downloads/logstash/logstash-${LOGSTASH_VERSION}.tar.gz | tar xzf - -C /opt \ 
    && mv /opt/logstash-${LOGSTASH_VERSION} /opt/logstash \
    && adduser -DH -s /sbin/nologin logstash \
    && mkdir -p /opt/logstash/data  \
    && rm -fr /opt/logstash/vendor/bundle/jruby/2.3.0 \
    && chown -R logstash: /opt/logstash

COPY entrypoint.sh /

ENV PATH ${PATH}:/opt/logstash/bin
WORKDIR /opt/logstash

USER logstash

# API Endpoint
EXPOSE 9600

# Port for input plugin (assuming a single plugin)
EXPOSE ${LOGSTASH_PORT}


ENTRYPOINT ["/entrypoint.sh"]

CMD ["start"]


