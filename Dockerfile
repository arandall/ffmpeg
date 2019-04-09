FROM alpine:3.9 AS build
MAINTAINER "Allan Randall <github@allanrandall.com>"
ENV FFMPEG_VERSION=4.1.3
ENV FFMPEG_SHA256SUM="2f5b24f30e41963ce80f0ab7c78a1b91e86fb3fbb4a7661147c572c587177eee ffmpeg-${FFMPEG_VERSION}.tar.gz"
ENV PREFIX=/fsroot

RUN apk add --update \
    build-base \
    bzip2 \
    coreutils \
    curl \
    freetype-dev \
    lame-dev \
    libass-dev \
    libogg-dev \
    libtheora-dev \
    libvorbis-dev \
    libvpx-dev \
    libwebp-dev \
    nasm \
    libressl-dev \
    opus-dev \
    rtmpdump-dev \
    tar \
    x264-dev \
    x265-dev \
    yasm-dev \
    zlib-dev

WORKDIR /tmp/src
RUN curl -sSO https://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.gz && \
    echo ${FFMPEG_SHA256SUM} | sha256sum --check

RUN tar zxvf ffmpeg-${FFMPEG_VERSION}.tar.gz -C .

WORKDIR /tmp/src/ffmpeg-${FFMPEG_VERSION}
ENV LIBRARY_PATH=/lib:/usr/lib
RUN ./configure \
    --prefix=${PREFIX} \
    --disable-debug \
    --enable-avresample \
    --enable-gpl \
    --enable-libass \
    --enable-libfreetype \
    --enable-libmp3lame \
    --enable-libopus \
    --enable-librtmp \
    --enable-libtheora \
    --enable-libvorbis \
    --enable-libvpx \
    --enable-libwebp \
    --enable-libx264 \
    --enable-libx265 \
    --enable-nonfree \
    --enable-libtls \
    --enable-postproc \
    --enable-small \
    --enable-version3
RUN make
RUN make install

RUN ldd ${PREFIX}/bin/ffmpeg | cut -d ' ' -f 3 | strings | xargs -I R cp R /${PREFIX}/lib/
RUN for lib in $(find /${PREFIX}/lib/* -type f -maxdepth 0); do strip --strip-all $lib; done
RUN LD_LIBRARY_PATH=${PREFIX}/lib /${PREFIX}/bin/ffmpeg -buildconf

FROM scratch
COPY --from=build /fsroot /
ENTRYPOINT ["/bin/ffmpeg"]
