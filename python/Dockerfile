# A Python 3 env

FROM dku/python-builder:3.6

# packages to be build (comma separated list)
ARG BUILD_PACKAGES=requests,dash

# A PYPI mirror can be set at build time (URL starting by https)
ARG PYPI_MIRROR=""

ENV PYTHON_VERSION 3.6

LABEL Description="Python 3 env"

# set mirror
RUN if [ -n "${PYPI_MIRROR}" ]; then pip config set global.index-url ${PYPI_MIRROR} ; h=${PYPI_MIRROR:7}; pip config set global.trusted-host ${h%%/*}; fi

RUN pip install ${BUILD_PACKAGES/,/ } 



# cleanup the tests directories and strip the binaries
RUN find /usr/lib/python${PYTHON_VERSION}/ -name 'tests' -exec rm -r '{}' + \
    && find /usr/lib/python${PYTHON_VERSION}/site-packages/ -name '*.so' -print -exec sh -c 'file "{}" | grep -q "not stripped" && strip -s "{}"' \;

