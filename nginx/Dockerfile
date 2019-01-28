ARG ALPINE_VERSION
FROM alpine:${ALPINE_VERSION:-3.8}

ARG IMAGE_REPO
ARG UID=1001
ARG DOCKER_GID=100

ENV NGINX_VERSION 1.12.2
ENV NGINX_CONF=/etc/nginx
ENV DOCKER_GEN_VERSION 0.7.4
# Reverse proxy can redirect services from PATH (http://host.domain/service/) or from a VHOST (http://service.domain/)
ENV URL_REDIRECTION PATH

LABEL description "Nginx ${NGINX_VERSION} server with Reverse Proxy and Static Files support"
LABEL usage "docker run -d --name nginx --network udn -e HOST_HOSTNAME=\$HOSTNAME -v \$HOME/cache:/data -v /var/run/docker.sock:/var/run/docker.sock:ro -p 80:80 ${IMAGE_REPO:-local}/nginx"

# creating nginx user with same UID as build/run user and docker group
RUN set -x && grep -q ":$DOCKER_GID:" /etc/group || addgroup -g $DOCKER_GID -S nginx
RUN set -x && grep -q ":[0-9]*:$UID:" /etc/passwd || adduser -u $UID -D -S -G nginx nginx

RUN apk update && apk add --no-cache nginx nginx-mod-http-echo curl

# download docker-gen
RUN set -x && curl -sL https://github.com/jwilder/docker-gen/releases/download/$DOCKER_GEN_VERSION/docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz |  tar xzf - -C /usr/bin 

RUN mkdir -m 777 /run/nginx \
    && chmod -R 777 /etc/nginx /var/log/nginx /var/tmp/nginx /var/lib/nginx \
    && chown root /usr/sbin/nginx && chmod +s /usr/sbin/nginx \
    && ln -fs /data/files/upload /upload


USER nginx:nginx

COPY entrypoint.sh /
COPY *.tmpl /etc/nginx/

EXPOSE 80 

VOLUME "/data"

VOLUME "/var/run/docker.sock"

ENTRYPOINT ["/entrypoint.sh"]

CMD ["start"]
