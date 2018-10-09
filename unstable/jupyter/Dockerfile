# A Python3 env including standard ML packages and an embeded jupyter server

# using a multi-stage build to produce a final image with minimal size (no compiler included!)
FROM alpine as builder

# additional packages to be added at build time (comma separated list)
ARG BUILD_PACKAGES=scikit-learn

# A PYPI mirror can be set at build time
ARG BUILD_PYPI_MIRROR=""

# Python version (given by Alpine repo, cannot be changed)
ENV PYTHON_VERSION 3.6

# install the build tools and the development libs
RUN apk add python3 g++ make file python3-dev curl coreutils musl-dev libffi-dev openssl-dev openblas-dev libpng-dev freetype-dev

# install the llvm6 libs from another image 
COPY --from=alpine-llvm /opt/llvm/* /opt/llvm/
RUN cp /opt/llvm/*.pub /etc/apk/keys && apk add /opt/llvm/*.apk && rm -fr /opt/llvm

RUN python3 -m ensurepip && pip3 install --upgrade pip setuptools 
# set mirror
RUN if [ -n "${BUILD_PYPI_MIRROR}" ]; then pip config set global.index-url ${BUILD_PYPI_MIRROR}; pip config set global.extra-index-url https://pypi.python.org/pypi ;fi
# as this is a builder we can use multiple RUNs
RUN pip install llvmlite # required for numba @jit 
RUN pip install cryptography requests # basic packages
RUN pip install numpy scipy # basic sci libs
RUN pip install numba # optimizer
RUN pip install --no-build-isolation Cython pandas # https://github.com/pypa/pip/issues/5299
RUN pip install jupyter  # notebook
RUN pip install matplotlib # plotting
RUN if [ -n "${BUILD_PACKAGES}" ]; then pip install ${BUILD_PACKAGES/,/} ; fi

# cleanup the tests directories and strip the binaries
RUN find /usr/lib/python${PYTHON_VERSION}/ -name 'tests' -exec rm -r '{}' + \
    && find /usr/lib/python${PYTHON_VERSION}/site-packages/ -name '*.so' -print -exec sh -c 'file "{}" | grep -q "not stripped" && strip -s "{}"' \;

# this is the main image
FROM alpine

# Versions (determined by alpine repo)
ENV JUPYTER_VERSION 4.4
ENV PYTHON_VERSION 3.6

# A PYPI mirror can be set at run time
ENV PYPI_MIRROR ""

# additional packages to install at start time (comma separated list) - C compilation not supported!
ENV EXTRA_PACKAGES ""

# Server Name and Port (used by reverse proxy to expose UI)
ENV VIRTUAL_HOST jupyter
ENV VIRTUAL_PORT 8888

# Image description
LABEL Description="Python lab $JUPYTER_VERSION (including Jupyter)"
LABEL Usage="docker run -d --name=${VIRTUAL_HOST} -e EXTRA_PACKAGES=plotly -e PYPI_MIRROR=\$PYPI_MIRROR --mount source=jupyter,target=/data -p ${VIRTUAL_PORT}:${VIRTUAL_PORT} jupyter"
LABEL Usage2="docker run -it --rm -e EXTRA_PACKAGES=avro-python3 -e https_proxy=\$https_proxy jupyter console"


RUN apk add --no-cache python3 libstdc++ openblas freetype libpng libffi openssl x264-libs git jq su-exec \
    && cd /usr/bin && ln -fs python3 python \
    && adduser -D -h /data jupyter

# copy all dependencies from the builder
COPY --from=builder /usr/lib/python${PYTHON_VERSION} /usr/lib/python${PYTHON_VERSION}
COPY --from=builder /usr/lib/libLLVM-6.0.so /usr/lib/
COPY --from=builder /usr/bin/pip* /usr/bin/
COPY --from=builder /usr/bin/jupyter* /usr/bin/
COPY --from=builder /usr/share/jupyter /usr/share/jupyter
COPY --from=builder /usr/etc/jupyter /usr/etc/jupyter

# copy ffmpeg/x264 for matplotlib.animations video convertion 
COPY --from=alpine-ffmpeg /usr/local/bin/ffmpeg /usr/local/bin/ffmpeg

COPY entrypoint.sh /
COPY README.ipynb /data
WORKDIR /data

EXPOSE ${VIRTUAL_PORT}

VOLUME /data

ENTRYPOINT ["/entrypoint.sh"]

CMD ["start"]
