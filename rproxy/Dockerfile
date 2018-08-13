FROM alpine

ARG SITE_DOWNLOAD=https://github.com/jwilder

ENV RPROXY_VERSION 1.0

ENV DOCKER_GEN_VERSION 0.7.4

# Server Name (required by CLI)
ENV SERVER_NAME rproxy

LABEL Description="Reverse Proxy ${PROXY_VERSION} Automated Server based on Nginx and docker-gen"

LABEL Usage="docker run -d --name=${SERVER_NAME} --network=udn -p 80:80 rproxy"

RUN apk update && apk add --no-cache nginx curl && rm -rf /var/cache/apk/* 

# download docker-gen
RUN set -x && curl -s ${SITE_DOWNLOAD}/docker-gen/releases/download/$DOCKER_GEN_VERSION/docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz |  tar xzf - -C /usr/bin 

COPY entrypoint.sh /
COPY nginx.tmpl /

EXPOSE 80

ENV DOCKER_HOST unix:///tmp/docker.sock

ENTRYPOINT ["/entrypoint.sh"]

CMD ["start"]
