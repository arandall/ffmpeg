FROM gliderlabs/alpine:3.6
MAINTAINER Bruno Celeste <bruno@coconut.co>

ENV FFMPEG_VERSION=4.0.2
ARG src_dir=/tmp/src

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

WORKDIR $src_dir
RUN curl -s http://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.gz | tar zxvf - -C .

WORKDIR /tmp/src/ffmpeg-${FFMPEG_VERSION}
RUN ./configure \
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
RUN make distclean

WORKDIR /tmp
RUN rm -rf ${src_dir}
RUN apk del \
    build-base \
    bzip2 \
    curl \
    nasm \
    tar \
    x264
RUN rm -rf /var/cache/apk/*

ENTRYPOINT ["ffmpeg"]
