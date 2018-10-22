# Alpine Linux with llvm6
#
# This image can be sourced with FROM or used in a multi-stage build
# The llvm6 apk(s) are available in /opt/llvm
#
# Note that build takes about 2 hours!
# Open PR for llvm6 package: https://github.com/alpinelinux/aports/pull/3583
# See https://stackoverflow.com/questions/50258121/building-llvm-6-under-linux-alpine

ARG ALPINE_VERSION

FROM alpine:${ALPINE_VERSION:-3.8}

ENV LLVM_VERSION 6

LABEL description "Alpine image with llvm6"

ENV TARGET_DIR /opt/llvm

# build the APK
RUN apk --update --virtual build-dependencies add alpine-sdk git diffutils build-base binutils-dev chrpath cmake file libffi-dev paxmark python2 py-setuptools zlib-dev \
    && adduser -D apk \
    && adduser apk abuild \
    && echo -e "export http_proxy=$http_proxy\nexport https_proxy=$https_proxy" >>/home/apk/.profile \
    && sudo -iu apk git clone --depth=1 -b pr-llvm-6 https://github.com/xentec/aports \ 
    && sudo -iu apk abuild-keygen -a  \
    && sudo -iu apk sh -xec 'cd /home/apk/aports/main/llvm6; abuild' \
    && mkdir -p $TARGET_DIR \
    && cp /home/apk/.abuild/*.rsa.pub $TARGET_DIR \
    && cp /home/apk/packages/main/$(uname -m)/*.apk $TARGET_DIR \
    && rm $TARGET_DIR/llvm6-static* && rm $TARGET_DIR/llvm6-test* \
    && deluser --remove-home apk \
    && apk del build-dependencies
