FROM alpine

ENV NGINX_VERSION 1.12.2

LABEL Description="NGINX ${NGINX_VERSION} Server"

LABEL Usage="docker run -d --name=nginx -p 80:80 nginx"

RUN apk update && apk add --no-cache nginx bash \
    && rm -rf /var/cache/apk/* \
    && mkdir /run/nginx

COPY entrypoint.sh /

EXPOSE 80


ENTRYPOINT ["/entrypoint.sh"]

CMD ["start"]
