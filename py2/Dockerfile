# A Python2 miniconda distribution

FROM alpine-glibc

# can be overriden to a local http cache
ARG URL_DOWNLOAD=""

# extra packages to install
ARG CONDA_PACKAGES=requests

# extra packages to install from forge
ARG CONDA_FORGE_PACKAGES=python-avro,faker

ENV LANG C.UTF-8


ENV PY2_VERSION 4.5
ENV CONDA_VERSION 4.5.1

LABEL Description="Python2 with miniconda ${CONDA_VERSION} "
LABEL Usage="docker run -ti --rm --network=udn py2"

ENV PATH /opt/conda/bin:$PATH

RUN set -x && \    
    echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    curl -s ${URL_DOWNLOAD:-https://repo.anaconda.com}/miniconda/Miniconda2-${CONDA_VERSION}-Linux-x86_64.sh -o ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh  && \
    conda config --add channels ${URL_DOWNLOAD:-https://repo.anaconda.com}/pkgs/main && \
    conda update --yes --name base conda && \
    conda install --yes ${CONDA_PACKAGES//,/ } && \
    conda config --add channels ${URL_DOWNLOAD:-https://conda.anaconda.org}/conda-forge && \
    conda install --yes ${CONDA_FORGE_PACKAGES//,/ }

CMD [ "python" ]

