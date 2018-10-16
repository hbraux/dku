# A Python 3 building environment with OS development libraries
# can be used in a multi-stage build

FROM alpine:3.8

# Python version is determined by Alpine repo
ENV PYTHON-BUILDER_VERSION 3.6

LABEL Description="Python 3 Builder"

# install the build tools and the development libs
RUN apk add --no-cache python3 g++ make file python3-dev curl coreutils musl-dev libffi-dev openssl-dev openblas-dev libpng-dev freetype-dev \
    && python3 -m ensurepip \
    && pip3 install --upgrade pip setuptools \
    && ln -fs /usr/bin/pip3 /usr/bin/pip \
    && ln -fs /usr/bin/python3 /usr/bin/python 
