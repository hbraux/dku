# A small version of ffmpeg with only x264 support (to be used for matplotlib)

from alpine

ENV FFMPEG_VERSION 4.0.2

# build the APK
RUN apk --virtual build-dependencies add --no-cache curl gcc make musl-dev coreutils freetype-dev x264-dev yasm \
    && curl -sL https://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.bz2  | tar xjf - -C /tmp \
    && cd /tmp/ffmpeg-${FFMPEG_VERSION}  \
    && ./configure --disable-debug --disable-doc --disable-ffplay --disable-ffprobe --enable-gpl --enable-libfreetype --enable-libx264 --enable-small  \
    && make && make install \
    && rm -fr /tmp/ffmpeg* \
    && apk del build-dependencies

RUN apk add --no-cache x264-libs freetype

RUN ldd /usr/local/bin/ffmpeg

