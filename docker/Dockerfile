FROM debian:stretch
LABEL maintainer="Taichicoin Developers <dev@taichicoin.org>"
LABEL description="Dockerised TaichicoinCore, built from Travis"

RUN apt-get update && apt-get -y upgrade && apt-get clean && rm -fr /var/cache/apt/*

COPY bin/* /usr/bin/
