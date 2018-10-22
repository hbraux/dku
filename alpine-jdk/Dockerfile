ARG ALPINE_VERSION
FROM alpine:${ALPINE_VERSION:-3.8}

ARG IMAGE_REPO

ENV JDK_VERSION 8

LABEL description "Alpine Linux with JDK ${JDK_VERSION}, bash and curl"
LABEL usage "docker run -it --rm ${IMAGE_REPO:-local}/alpine-jdk bash"

ENV LANG C.UTF-8
ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk
ENV PATH $PATH:$JAVA_HOME/bin

RUN apk add --no-cache bash ca-certificates curl libc6-compat openjdk8-jre-base

