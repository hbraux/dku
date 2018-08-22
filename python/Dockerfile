# a minimal python3 runtime image (<60MB)

FROM alpine:3.8

# A PYPI MIROR can be set
ARG MIRROR_PYPI=""

ENV PYTHON_VERSION 3.6

RUN set -x && apk add --no-cache python3 \
    && python3 -m ensurepip \
    && pip3 install --upgrade pip setuptools \
    && rm -r /root/.cache \
    && cd /usr/bin && ln -fs python3 python \
    && if [ -n "${MIRROR_PYPI}" ] ; then pip config set global.index-url ${MIRROR_PYPI}/simple; pip config set global.index ${MIRROR_PYPI}/pypi; fi

CMD ["python"]

