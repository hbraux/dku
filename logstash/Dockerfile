FROM jdk:8

ARG URL_ELASTIC=http://artifacts.elastic.co/downloads

ENV LOGSTASH_VERSION 5.6.6

ENV IMAGE_INFO Logstash ${LOGSTASH_VERSION} Development Server 

RUN set -x && mkdir -p /opt \
    && curl -s ${URL_ELASTIC}/logstash/logstash-${LOGSTASH_VERSION}.tar.gz | tar xzf - -C /opt \ 
    && mv /opt/logstash-${LOGSTASH_VERSION} /opt/logstash \
    && adduser -DH -s /sbin/nologin logstash \
    && mkdir -p /opt/logstash/data  \
    && rm -fr /opt/logstash/vendor/bundle/jruby/2.3.0 \
    && chown -R logstash: /opt/logstash

COPY entrypoint.sh /

ENV PATH ${PATH}:/opt/logstash/bin
WORKDIR /opt/logstash

USER logstash

# Input plugins
EXPOSE 5000 5001

# no volume needed
# VOLUME /opt/logstash/data

ENTRYPOINT ["/entrypoint.sh"]

CMD ["help"]


