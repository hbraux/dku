# A Python 3 building environment with OS development libraries
# can be used in a multi-stage build

FROM alpine:3.8

# Python version is determined by Alpine repo
ENV PYTHON_VERSION 3.6
ENV PYTHON-BUILDER_VERSION 3.6

# A PYPI mirror can be set (URL must start by https)
ARG PYPI_MIRROR=""

LABEL Description="Python ${PYTHON_VERSION} Builder"

# install the build tools and the development libs
RUN apk add --no-cache python3 g++ make file python3-dev curl coreutils musl-dev libffi-dev openssl-dev openblas-dev libpng-dev freetype-dev

RUN python3 -m ensurepip \
    && pip3 install --upgrade pip setuptools \
    && ln -fs /usr/bin/pip3 /usr/bin/pip \
    && ln -fs /usr/bin/python3 /usr/bin/python 


RUN if [ -n "${PYPI_MIRROR}" ]; then pip config set global.index-url ${PYPI_MIRROR} ; h=${PYPI_MIRROR:7}; pip config set global.trusted-host ${h%%/*}; fi

