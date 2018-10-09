# Alpine with glibc
# Required for conda 
# Note that Alpine is provided with muscl and not supposed to support glibc 
# https://wiki.alpinelinux.org/wiki/Running_glibc_programs

# Also install curl, certificates, bash, git

FROM alpine:3.7

ARG SITE_DOWNLOAD=https://github.com/sgerrand

ENV GLIBC_VERSION 2.27-r0

ENV URL_GLIBC ${SITE_DOWNLOAD}/alpine-pkg-glibc/releases/download

ENV LANG=C.UTF-8

RUN set -x && apk update && apk add --no-cache curl ca-certificates bash git \
    && curl -s https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub -o /etc/apk/keys/sgerrand.rsa.pub \
    && cd /tmp  \
    && curl -sO $URL_GLIBC/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk \
    && curl -sO $URL_GLIBC/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk \
    && curl -sO $URL_GLIBC/${GLIBC_VERSION}/glibc-i18n-${GLIBC_VERSION}.apk \
    && apk add --no-cache glibc*.apk  \
    && rm -f glibc*apk /etc/apk/keys/sgerrand.rsa.pub \
    && /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 ${LANG} || true\
    && echo "export LANG=$LANG" > /etc/profile.d/locale.sh \
    && apk del glibc-i18n \
    && rm -rf /var/cache/apk/* 

CMD "/bin/bash"


