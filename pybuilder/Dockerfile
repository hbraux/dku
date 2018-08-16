# Python image with all build dependencies (gcc, etc.) to be used in a multi-stage Docker build 

FROM python

ENV PYBUILDER_VERSION 1.0

RUN apk add --no-cache g++ gfortran file binutils musl-dev python3-dev openblas-dev \
    && ln -s locale.h /usr/include/xlocale.h 

# also install Cython which is required for pandas
RUN pip install Cython



