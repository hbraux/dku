# Alpine with glibc
# Required for conda 
# Note that Alpine is provided with muscl and not supposed to support glibc 
# https://wiki.alpinelinux.org/wiki/Running_glibc_programs

# Also provides curl, certificates, bash and git

FROM alpine:3.7

ARG URL_DOWNLOAD=https://github.com/sgerrand

ENV ALPINE-GLIBC_VERSION 3.7

ENV URL_GLIBC ${URL_DOWNLOAD}/alpine-pkg-glibc/releases/download
ENV VERS_GLIBC 2.27-r0

ENV LANG=C.UTF-8

RUN apk update && apk add --no-cache curl ca-certificates bash git

RUN set -x && cd /tmp &&  \
    curl -s https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub -o /etc/apk/keys/sgerrand.rsa.pub && \
    curl -sO $URL_GLIBC/$VERS_GLIBC/glibc-$VERS_GLIBC.apk && \
    curl -sO $URL_GLIBC/$VERS_GLIBC/glibc-bin-$VERS_GLIBC.apk && \
    curl -sO $URL_GLIBC/$VERS_GLIBC/glibc-i18n-$VERS_GLIBC.apk && \
    ls -l && \
    apk add --no-cache glibc*.apk && \
    rm -f glibc*apk /etc/apk/keys/sgerrand.rsa.pub && \
    /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 ${LANG} || true && \
    echo "export LANG=$LANG" > /etc/profile.d/locale.sh && \
    apk del glibc-i18n && \
    rm -rf /var/cache/apk/*

CMD "/bin/bash"


