# Minimal FFmpeg Docker image with dynamically linked ELF binaries

This docker file was originally born out of my need to run the latest FFmpeg version. Over time I have combined other
work to create an image that is only **64.3MB** and is avaiable via https://hub.docker.com/r/arandall/ffmpeg/

Inspired by;
 * Bruno Celeste - https://github.com/opencoconut/ffmpeg
 * http://blog.oddbit.com/2015/02/05/creating-minimal-docker-images/

The image is 

Current FFmpeg version: `4.1`

## FFmpeg Build Configuration

```
22:50 $ docker run ffmpeg -buildconf
ffmpeg version 4.1 Copyright (c) 2000-2018 the FFmpeg developers
  built with gcc 6.4.0 (Alpine 6.4.0)
  configuration: --prefix=/fsroot --disable-debug --enable-avresample --enable-gpl --enable-libass --enable-libfreetype --enable-libmp3lame --enable-libopus --enable-librtmp --enable-libtheora --enable-libvorbis --enable-libvpx --enable-libwebp --enable-libx264 --enable-libx265 --enable-nonfree --enable-libtls --enable-postproc --enable-small --enable-version3
  libavutil      56. 22.100 / 56. 22.100
  libavcodec     58. 35.100 / 58. 35.100
  libavformat    58. 20.100 / 58. 20.100
  libavdevice    58.  5.100 / 58.  5.100
  libavfilter     7. 40.101 /  7. 40.101
  libavresample   4.  0.  0 /  4.  0.  0
  libswscale      5.  3.100 /  5.  3.100
  libswresample   3.  3.100 /  3.  3.100
  libpostproc    55.  3.100 / 55.  3.100

  configuration:
    --prefix=/fsroot
    --disable-debug
    --enable-avresample
    --enable-gpl
    --enable-libass
    --enable-libfreetype
    --enable-libmp3lame
    --enable-libopus
    --enable-librtmp
    --enable-libtheora
    --enable-libvorbis
    --enable-libvpx
    --enable-libwebp
    --enable-libx264
    --enable-libx265
    --enable-nonfree
    --enable-libtls
    --enable-postproc
    --enable-small
    --enable-version3
```

## Usage

```
$ docker run opencoconut/ffmpeg -i http://files.coconut.co.s3.amazonaws.com/test.mp4 -f webm -c:v libvpx -c:a libvorbis - > test.webm
```

To encode a local file, you can mount the current path on the Docker host's filesystem as a volume inside the container like this:

```
$ docker run -v=`pwd`:/tmp/ffmpeg opencoconut/ffmpeg -i localfile.mp4 out.webm
```

You can create an alias so you use the Docker container like if FFmpeg is installed on your computer:

In `~/.bashrc`:

```
alias ffmpeg='docker run -v=`pwd`:/tmp/ffmpeg opencoconut/ffmpeg'
```

Now we can execute FFmpeg with just:

```
$ ffmpeg -buildconf
```
