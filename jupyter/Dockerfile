# A Python3 miniconda environment with Jupyter server

FROM alpine-glibc

# can be overriden to a local http cache
ARG URL_DOWNLOAD=""

ARG CONDA_PACKAGES=matplotlib,pandas,jupyter,scikit-learn,plotly,quandl

ARG CONDA_FORGE_PACKAGES=""

ENV LANG C.UTF-8

ENV JUPYTER_VERSION 4.4
ENV CONDA_VERSION 4.4.10

LABEL Description="Conda/Jupyter Server $JUPYTER_VERSION"
LABEL Usage="docker run -d --name=jupyter --network=udn --mount source=jupyter,target=/data -p 8888:8888 jupyter start"

ENV PATH /opt/conda/bin:$PATH

RUN set -x  \    
    && echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh \
    && curl -s ${URL_DOWNLOAD:-https://repo.anaconda.com}/miniconda/Miniconda3-${CONDA_VERSION}-Linux-x86_64.sh -o ~/miniconda.sh \
    && /bin/bash ~/miniconda.sh -b -p /opt/conda \
    && rm ~/miniconda.sh  \
    && conda config --add channels ${URL_DOWNLOAD:-https://repo.anaconda.com}/pkgs/main \
    && conda update --yes --name base conda \
    && conda install --yes ${CONDA_PACKAGES//,/ } \
    && adduser -D -h /data -s /bin/bash jupyter

RUN test -n "$CONDA_FORGE_PACKAGES" && set -x && conda config --add channels ${URL_DOWNLOAD:-https://conda.anaconda.org}/conda-forge && conda install --yes ${CONDA_FORGE_PACKAGES//,/ } || :

COPY entrypoint.sh /

USER jupyter

WORKDIR /data

EXPOSE 8888

VOLUME /data

ENTRYPOINT ["/entrypoint.sh"]

CMD ["start"]

