#!/bin/bash

RELEASE=main
OMLDIR=/opt/omnileads/

git clone https://github.com/psychedelicto/omnileads-onpremise-cluster.git
git checkout $RELEASE
mkdir -p $OMLDIR
cp files/docker-compose.yml $OMLDIR
cp files/redis-service /etc/systemd/system

cd $OMLDIR/redis
docker-compose up -d

reboot
