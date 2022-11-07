FROM alpine:3.16.2

RUN apk add --update unzip build-base curl nasm \
  zlib-dev openssl-dev yasm-dev lame-dev libogg-dev \
  x264-dev libvpx-dev libvorbis-dev x265-dev freetype-dev \
  libass-dev libwebp-dev rtmpdump-dev libtheora-dev opus-dev

RUN DIR=$(mktemp -d) && cd ${DIR}

RUN curl -L -o ffmpeg.zip https://github.com/jjustman/ffmpeg-hls-pts-discontinuity-reclock/archive/refs/heads/master.zip && \
  unzip ffmpeg.zip && \
  cd ffmpeg-hls-pts-discontinuity-reclock-master && \
  ./configure \
  --enable-version3 --enable-gpl --enable-nonfree --enable-small --enable-libmp3lame --enable-libx264 --enable-libx265 --enable-libvpx --enable-libtheora --enable-libvorbis --enable-libopus --enable-libass --enable-libwebp --enable-librtmp --enable-postproc --enable-avresample --enable-libfreetype --enable-openssl --disable-debug && \
  make && \
  make install && \
  make distclean

RUN mv /usr/local/bin/ff* /usr/bin

RUN rm -rf ${DIR} && \
  apk del build-base curl unzip x264 openssl nasm openssl-dev yasm-dev && \
  rm -rf /var/cache/apk/*

ENTRYPOINT [ "ffmpeg" ]