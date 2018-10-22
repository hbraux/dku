ARG ALPINE_VERSION
FROM alpine:${ALPINE_VERSION:-3.8}

ARG IMAGE_REPO
ARG PYPI_MIRROR

# build-time packages (comma separated list)
ARG BUILD_PACKAGES="requests"

ENV PYTHON_MAJOR_VERSION 3
ENV PYTHON_VERSION 3.6
ENV ALPINE-PYTHON_VERSION 3.6

# run time packages  (comma separated list)
ENV PACKAGES ""

LABEL description "Alpine Linux with Python ${PYTHON_VERSION}"
LABEL usage "docker run -it --rm -e PACKAGES=\$PACKAGES ${IMAGE_REPO:-local}/alpine-python"

RUN apk add --no-cache python3 \
    && python3 -m ensurepip \
    && ln -fs /usr/bin/pip3 /usr/bin/pip \
    && ln -fs /usr/bin/python3 /usr/bin/python


RUN if [ -n "$PYPI_MIRROR" ] ; then pip config set global.index-url ${PYPI_MIRROR} ; h=${PYPI_MIRROR:8} ; pip config set global.trusted-host ${h%%/*}; fi \
    && pip install --upgrade pip \
    && pip install ${BUILD_PACKAGES/,/ }

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]

CMD ["python"]



