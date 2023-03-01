#!/usr/bin/env bash

export LC_ALL=C

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR/.. || exit

DOCKER_IMAGE=${DOCKER_IMAGE:-taichicoin/taichicoind-develop}
DOCKER_TAG=${DOCKER_TAG:-latest}

BUILD_DIR=${BUILD_DIR:-.}

rm docker/bin/*
mkdir docker/bin
cp $BUILD_DIR/src/taichicoind docker/bin/
cp $BUILD_DIR/src/taichicoin-cli docker/bin/
cp $BUILD_DIR/src/taichicoin-tx docker/bin/
strip docker/bin/taichicoind
strip docker/bin/taichicoin-cli
strip docker/bin/taichicoin-tx

docker build --pull -t $DOCKER_IMAGE:$DOCKER_TAG -f docker/Dockerfile docker
