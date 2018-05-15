FROM alpine-jdk:8

ARG URL_DOWNLOAD=http://apache.crihan.fr

ENV SPARK_VERSION 1.6.3


# supported values: low, default, or a size
ENV HEAP low

ENV SERVER_NAME spark

LABEL Description="Spark ${SPARK_VERSION} standalone server"
LABEL Usage="docker run -d --name=${SERVER_NAME} -h ${SERVER_NAME} --mount source=spark,target=/data --network=udn -p 7080:7080 spark start"
LABEL Usage2="docker run -it --rm --network=udn spark pyspark --master spark://spark:7077"
LABEL Usage3="docker cp test.py spark:/data && docker run -it --rm -v spark:/data --network=udn spark spark-submit /data/test.py --master spark://spark:7077"

# add python2 for pyspark
RUN set -x && apk add --no-cache python2  libc6-compat \
    && mkdir -p /opt  \
    && curl -s ${URL_DOWNLOAD}/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop2.6.tgz | tar xzf - -C /opt \
    && mv /opt/spark-${SPARK_VERSION}-bin-hadoop2.6 /opt/spark \
    && adduser -D -s /sbin/nologin spark \
    && mkdir -p /opt/spark/logs \
    && chown -R spark: /opt/spark \
    #cleanup
    && cd /opt/spark && rm -fr CHANGES.txt R examples ec2 lib/*examples*

COPY entrypoint.sh /

ENV PATH ${PATH}:/opt/spark/bin
WORKDIR /opt/spark

USER spark

# Spark master
EXPOSE 7077

# Spark master UI
EXPOSE 7080

# the volume is just to upload file to server
VOLUME /data

ENTRYPOINT ["/entrypoint.sh"]

CMD ["help"]


