# A jupyter notebook with ML libs

# using a multi-stage build 
FROM pybuilder as builder

ARG ML_LIBS=scikit-learn

RUN if [ -n "${MIRROR_PYPI}" ]; then pip config set global.index-url ${MIRROR_PYPI}/simple; pip config set global.extra-index-url https://pypi.python.org/pypi ;fi

RUN pip install llvmlite # required for numba @jit, need llvm6 libs
RUN pip install cryptography requests # basic packages
RUN pip install numpy scipy # basic sci libs
RUN pip install numba # optimizer
RUN pip install --no-build-isolation Cython pandas # https://github.com/pypa/pip/issues/5299
RUN pip install jupyter 
RUN pip install matplotlib plotly # plotting
RUN if [ -n "${ML_LIBS}" ]; then pip install ${ML_LIBS/,/} ; fi

# cleanup the tests directories and strip the binaries
RUN find /usr/lib/python${PYTHON_VERSION}/ -name 'tests' -exec rm -r '{}' + \
    && find /usr/lib/python${PYTHON_VERSION}/site-packages/ -name '*.so' -print -exec sh -c 'file "{}" | grep -q "not stripped" && strip -s "{}"' \;

# this is the main image
FROM alpine

ENV PYTHON_VERSION 3.6
ENV JUPYTER_VERSION 4.4

# the Notebook can be synced with a Git Repo
ENV GIT_REPO ""

# Server Name and Port (used by reverse proxy to expose UI)
ENV VIRTUAL_HOST jupyter
ENV VIRTUAL_PORT 8888

# additional packages to install at start time (comma separated list)
ENV PYPI_PACKAGES avro

LABEL Description="Jupyter Server $JUPYTER_VERSION"
LABEL Usage="docker run -d --name=${VIRTUAL_HOST} --network=udn --mount source=jupyter,target=/data -p ${VIRTUAL_PORT}:${VIRTUAL_PORT} jupyter"

RUN apk add --no-cache python3 libstdc++ openblas freetype libpng libffi libxml2 openssl ffmpeg git jq su-exec \
    && cd /usr/bin && ln -fs python3 python \
    && adduser -D -h /data jupyter

# copy all deêndencies from the builder
COPY --from=builder /usr/lib/python${PYTHON_VERSION} /usr/lib/python${PYTHON_VERSION}
COPY --from=builder /usr/lib/libLLVM-6.0.so /usr/lib/
COPY --from=builder /usr/bin/pip* /usr/bin/
COPY --from=builder /usr/bin/jupyter* /usr/bin/
COPY --from=builder /usr/share/jupyter /usr/share/jupyter
COPY --from=builder /usr/etc/jupyter /usr/etc/jupyter

COPY entrypoint.sh /

WORKDIR /data

EXPOSE ${VIRTUAL_PORT}

VOLUME /data

ENTRYPOINT ["/entrypoint.sh"]

CMD ["start"]

