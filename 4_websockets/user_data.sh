#!/bin/bash

REPO_URL=https://github.com/psychedelicto/omnileads-onpremise-cluster.git
REPO_RELEASE=onpre-001-oml-2-punto-0

export SRC=/usr/src
export COMPONENT_REPO=https://gitlab.com/omnileads/omnileads-websockets.git
export COMPONENT_RELEASE=develop

export REDIS_HOST=192.168.95.201
export REDIS_PORT=6379
export WEBSOCKET_PORT=8000

yum -y install git
git clone $REPO_URL
cd omnileads-onpremise-cluster
git checkout $REPO_RELEASE
chmod +x 4_websockets/websockets_install.sh
./4_websockets/websockets_install.sh
