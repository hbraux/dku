FROM alpine

ENV JDK_VERSION 8

LABEL Description="Alpine OpenJDK ${JDK_VERSION} with bash"
LABEL Usage="docker run -it --rm alpine-jdk bash"

ENV LANG C.UTF-8
ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk
ENV PATH $PATH:$JAVA_HOME/bin

# also install curl and bash 8.151.12-r0

RUN apk add --no-cache bash ca-certificates curl libc6-compat openjdk8-jre-base \
    # remove useless Bash terms to reduce image size to minimal
    && cd /usr/share/terminfo && ls | grep -v 'xterm$' | xargs rm -fr

