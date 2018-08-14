FROM alpine

ARG SITE_DOWNLOAD=https://github.com/jwilder

ENV RPROXY_VERSION 1.0
ENV DOCKER_GEN_VERSION 0.7.4

ENV DOMAIN=hostonly.com

LABEL Description="Reverse Proxy Server ${RPROXY_VERSION} based on Nginx and docker-gen"

LABEL Usage="docker run -d --name=rproxy -e DOMAIN=${DOMAIN} -v /var/run/docker.sock:/var/run/docker.sock --network=udn -p 80:80 rproxy"

RUN apk update && apk add --no-cache nginx curl && rm -rf /var/cache/apk/* 

# download docker-gen
RUN set -x && curl -s ${SITE_DOWNLOAD}/docker-gen/releases/download/$DOCKER_GEN_VERSION/docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz |  tar xzf - -C /usr/bin && mkdir -m 777 /run/nginx 

COPY entrypoint.sh /
COPY nginx.tmpl /etc/nginx/

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]

CMD ["start"]
