FROM alpine:3.9 AS build
MAINTAINER "Allan Randall <github@allanrandall.com>"
ENV FFMPEG_VERSION 4.1.4
ENV FFMPEG_SHA256SUM "7570d3403e26b34873090a5904cb513b130425972cfcff8d9ea59df5e88846d1 ffmpeg-${FFMPEG_VERSION}.tar.gz"
ENV PREFIX /fsroot

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
RUN make -j $(nproc)
RUN make install

RUN ldd ${PREFIX}/bin/ffmpeg | cut -d ' ' -f 3 | strings | xargs -I R cp R /${PREFIX}/lib/
RUN for lib in $(find /${PREFIX}/lib/* -type f -maxdepth 0); do strip --strip-all $lib; done
RUN LD_LIBRARY_PATH=${PREFIX}/lib /${PREFIX}/bin/ffmpeg -buildconf

FROM scratch
COPY --from=build /fsroot /
ENTRYPOINT ["/bin/ffmpeg"]
