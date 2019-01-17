ARG IMAGE_REPO
FROM ${IMAGE_REPO}/alpine-jdk:8

ARG IMAGE_REPO
ARG HTTP_MIRROR=https://downloads.lightbend.com

ENV SCALA_VERSION 2.12.8

LABEL description "Alpine Scala ${SCALA_VERSION} console"
LABEL usage "docker run -it --rm ${IMAGE_REPO:-local}/alpine-scala"

# adding 3p dependencies: libgomp for XGBoost 
RUN apk add --no-cache libgomp 

RUN set -x && mkdir -p /opt \
    && curl -s ${HTTP_MIRROR}/scala/${SCALA_VERSION}/scala-${SCALA_VERSION}.tgz | tar xzf - -C /opt \
    && mv /opt/scala-${SCALA_VERSION} /opt/scala \
    && JAVA_VERSION=$(java -version 2>&1 | sed -n 's/openjdk version "\(.*\)"/\1/p') \
    && echo "JAVA_VERSION=$JAVA_VERSION" > $JAVA_HOME/release \
    && adduser -D scala \
    && chown -R scala: /opt/scala

ENV PATH ${PATH}:/opt/scala/bin

COPY entrypoint.sh /opt/scala/bin/
COPY inputrc /home/scala/.inputrc

USER scala
WORKDIR /home/scala

ENTRYPOINT ["/opt/scala/bin/entrypoint.sh"]

CMD ["scala"]




