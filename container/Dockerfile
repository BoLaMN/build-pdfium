FROM ubuntu:xenial

RUN \
  dpkg --add-architecture i386 && \
  apt-get update && \
  apt-get install -y \
    build-essential \
    git \
    subversion \
    pkg-config \
    python \
    libtool \
    cmake \
    glib2.0-dev \
    wget 

# Create a default, non-root 'build' user
RUN groupadd -r build && useradd -m -g build build
WORKDIR /data
USER build
