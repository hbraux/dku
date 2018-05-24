FROM alpine:3.7

ARG URL_DOWNLOAD=""

ENV BIGCHAIN_VERSION 2.0
ENV TENDERMINT_VERSION 0.19.5

# chain ID and Genesis time
ENV CHAIN_ID testchain
ENV GENESIS_TIME 2018-05-01T00:00:00

ENV SERVER_NAME bigchain
LABEL Description="BigchainDB ${BIGCHAIN_VERSION} standalone server with Tendermint and MongoDB"
LABEL Usage="docker run -d --name=${SERVER_NAME} --network=udn --mount source=bigchain,target=/data -p 9984:9984 -p 9985:9985 -p 46656:46656 -p 46657:46657 bigchain start"
LABEL Usage2="docker run -it --rm --network=udn bigchain mongo-shell"

# install Linux dependencies and MongoDB
RUN mkdir -p /data/db && apk update && apk add --no-cache curl bash g++ make musl-dev python3 python3-dev libffi-dev libressl-dev mongodb unzip

# install Tendermint (single binary)
ENV TMHOME /data/tendermint
RUN set -x && cd /tmp && curl -s ${URL_DOWNLOAD:-https://s3-us-west-2.amazonaws.com/tendermint/binaries}/tendermint/releases/download/${TENDERMINT_VERSION}/tendermint_${TENDERMINT_VERSION}_linux_amd64.zip -O && unzip -d /bin *.zip && rm -f *.zip 

# Install BigChainDB from source (2.0)
COPY bigchaindb /usr/src/app
WORKDIR /usr/src/app
RUN set -x && pip3 install --no-cache-dir --process-dependency-links . && pip3 install --no-cache-dir .

# keyring can be updated?
ENV BIGCHAINDB_KEYRING ""

COPY entrypoint.sh /

# BigChainDB HTTP API
EXPOSE 9984 

# BigChainDB WebSocket Event Stream API
EXPOSE 9985

# Tendermint RPC port 
EXPOSE 46656

# Tendermint API port
EXPOSE 46657

VOLUME /data

ENTRYPOINT [ "/entrypoint.sh" ]

CMD [ "start"]
