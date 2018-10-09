FROM alpine:3.8

ENV JDK_VERSION 8

LABEL Description="Alpine Linux with JDK ${JDK_VERSION}, bash and curl"
LABEL Usage="docker run -it --rm dku/alpine-jdk bash"

ENV LANG C.UTF-8
ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk
ENV PATH $PATH:$JAVA_HOME/bin

RUN apk add --no-cache bash ca-certificates curl libc6-compat openjdk8-jre-base

