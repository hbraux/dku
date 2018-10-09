FROM alpine:3.7

ARG SITE_DOWNLOAD=https://github.com/jwilder

ENV NGINX_VERSION 1.12.2

ENV DOCKER_GEN_VERSION 0.7.4

LABEL Description="Nginx ${NGINX_VERSION} server with Reverse Proxy and Static Files support"

LABEL Usage="docker run -d --name=nginx --network=udn -e DOCKER_HOST=\$DOCKER_HOST --mount source=nginx,target=/data -v /var/run/docker.sock:/var/run/docker.sock -p 80:80 dku/nginx"

RUN apk update && apk add --no-cache nginx curl && rm -rf /var/cache/apk/* 

# download docker-gen
RUN set -x && curl -sL https://github.com/jwilder/docker-gen/releases/download/$DOCKER_GEN_VERSION/docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz |  tar xzf - -C /usr/bin && mkdir -m 777 /run/nginx 

COPY entrypoint.sh /
COPY nginx.tmpl /etc/nginx/

EXPOSE 80

VOLUME /data

VOLUME "/var/run/docker.sock"

ENTRYPOINT ["/entrypoint.sh"]

CMD ["start"]
