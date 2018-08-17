# A minimal jupyter notebook

# using a multi-stage build 
FROM pybuilder as builder

RUN pip install cryptography requests # basic packages
RUN pip install numpy
RUN pip install scipy scikit-learn #  ML
RUN pip install --no-build-isolation pandas # https://github.com/pypa/pip/issues/5299
RUN pip install jupyter 
RUN pip install matplotlib plotly # plotting

# cleanup the tests directories and strip the binaries
RUN find /usr/lib/python${PYTHON_VERSION}/ -name 'tests' -exec rm -r '{}' + \
    && find /usr/lib/python${PYTHON_VERSION}/site-packages/ -name '*.so' -print -exec sh -c 'file "{}" | grep -q "not stripped" && strip -s "{}"' \; 

# this is the main image
FROM alpine:3.8

ENV PYTHON_VERSION 3.6
ENV JUPYTER_VERSION 4.4

# Server Name and Port (used by reverse proxy to expose UI)
ENV VIRTUAL_HOST jupyter
ENV VIRTUAL_PORT 8888

LABEL Description="Jupyter Server $JUPYTER_VERSION"
LABEL Usage="docker run -d --name=${VIRTUAL_HOST} --network=udn --mount source=jupyter,target=/data -p ${VIRTUAL_PORT}:${VIRTUAL_PORT} jupyter"

RUN apk add --no-cache python3 libstdc++ openblas freetype libpng libffi openssl \
    && cd /usr/bin && ln -fs python3 python \
    && adduser -D -h /data jupyter

COPY --from=builder /usr/lib/python${PYTHON_VERSION} /usr/lib/python${PYTHON_VERSION}
COPY --from=builder /usr/bin/jupyter* /usr/bin/
COPY --from=builder /usr/share/jupyter /usr/share/jupyter
COPY --from=builder /usr/etc/jupyter /usr/etc/jupyter
COPY entrypoint.sh /

USER jupyter

WORKDIR /data

EXPOSE ${VIRTUAL_PORT}

VOLUME /data

ENTRYPOINT ["/entrypoint.sh"]

CMD ["start"]

