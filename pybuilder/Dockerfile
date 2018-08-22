# Python image with all build dependencies (gcc, etc.) and predownlaod packages
# to be used in a multi-stage Docker build 

FROM alpine-llvm 

FROM alpine

ENV PYTHON_VERSION 3.6
ENV PYBUILDER_VERSION 3.6

# Add LLVM 6
COPY --from=alpine-llvm /opt/llvm/*.apk /tmp/
RUN apk add --allow-untrusted /tmp/*.apk && rm -f /tmp/*.apk

RUN apk add --no-cache python3 g++ gfortran file binutils cmake make \
    musl-dev python3-dev openblas-dev freetype-dev libpng-dev libffi-dev openssl-dev zlib-dev bzip2-dev libxml2-dev ffmpeg-dev \
    && ln -s locale.h /usr/include/xlocale.h 

RUN python3 -m ensurepip && pip3 install --upgrade pip setuptools

RUN pip download llvmlite cryptography requests numpy scipy scikit-learn numba Cython pandas jupyter matplotlib plotly 

