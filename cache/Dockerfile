FROM alpine


# Version of the server
ENV CACHE_VERSION 0.1

# Warning: DOCKER_HOST must be an @IP for FTP Passive mode
ENV DOCKER_HOST 127.0.0.1

# HTTP Port
ENV HTTP_PORT 8080

# Passive Port Range for FTP (5 should be enough)
ENV PASV_MIN_PORT 21001
ENV PASV_MAX_PORT 21005

LABEL Description="HTTP/FTP Cache Server V${CACHE_VERSION} with upload support"

LABEL Usage="docker run -d --name=cache-server -e DOCKER_HOST=\$DOCKER_HOST --mount source=cache,target=/data  -p ${HTTP_PORT}:${HTTP_PORT} -p 21:21 -p ${PASV_MIN_PORT}-${PASV_MAX_PORT}:${PASV_MIN_PORT}-${PASV_MAX_PORT} cache"

RUN apk update && apk add --no-cache apache2 vsftpd \
    && rm -rf /var/cache/apk/*

COPY entrypoint.sh /

EXPOSE ${HTTP_PORT}
EXPOSE 21 
EXPOSE ${PASV_MIN_PORT}-${PASV_MAX_PORT}

VOLUME /data

ENTRYPOINT ["/entrypoint.sh"]

CMD ["start"]
