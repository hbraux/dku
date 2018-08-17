# Python image with all build dependencies (gcc, etc.) to be used in a multi-stage Docker build 

FROM alpine:3.8

ENV PYTHON_VERSION 3.6
ENV PYBUILDER_VERSION 3.6

RUN apk add --no-cache python3 g++ gfortran file binutils musl-dev python3-dev openblas-dev freetype-dev libpng-dev libffi-dev openssl-dev zlib-dev bzip2-dev \
    && ln -s locale.h /usr/include/xlocale.h 

RUN python3 -m ensurepip \
    && pip3 install --upgrade pip setuptools \
    # install Cython which is required for pandas
    && pip install Cython
