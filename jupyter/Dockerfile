# using a multi-stage build to reduce the final image size

FROM pybuild

# ARG MIRROR_PYPI=""
# RUN if [ -n "${MIRROR_PYPI}" ]; then pip config set global.index-url ${MIRROR_PYPI}/simple ; pip config set global.index ${MIRROR_PYPI}/pypi; fi 

RUN pip install numpy
RUN pip install --no-build-isolation pandas # https://github.com/pypa/pip/issues/5299
RUN pip install jupyter

# cleanup the tests directories and strip the binaries
RUN find /usr/lib/python${PYTHON_VERSION}/ -name 'tests' -exec rm -r '{}' + \
    && find /usr/lib/python${PYTHON_VERSION}/site-packages/ -name '*.so' -print -exec sh -c 'file "{}" | grep -q "not stripped" && strip -s "{}"' \; 

FROM python

# adding C libs
RUN apk add libstdc++ openblas

ENV JUPYTER_VERSION 5

# Server Name and Port (used by reverse proxy to expose UI)
ENV VIRTUAL_HOST jupyter
ENV VIRTUAL_PORT 8888

LABEL Description="Jupyter Server $JUPYTER_VERSION"
LABEL Usage="docker run -d --name=${VIRTUAL_HOST} --network=udn --mount source=jupyter,target=/data -p ${VIRTUAL_PORT} jupyter"

COPY --from=0 /usr/lib/python${PYTHON_VERSION} /usr/lib/python${PYTHON_VERSION}
COPY --from=0 /usr/bin/jupyter* /usr/bin/
COPY --from=0 /usr/share/jupyter /usr/share/jupyter
COPY --from=0 /usr/etc/jupyter /usr/etc/jupyter
COPY entrypoint.sh /

RUN adduser -DH -s /sbin/nologin jupyter

USER jupyter

WORKDIR /data

EXPOSE ${VIRTUAL_PORT}

VOLUME /data

ENTRYPOINT ["/entrypoint.sh"]

CMD ["start"]

