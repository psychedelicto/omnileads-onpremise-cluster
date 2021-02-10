#!/bin/bash

RELEASE=main
OMLDIR=/opt/omnileads/
INSTALL_DOCKER=TRUE

git clone https://github.com/psychedelicto/omnileads-onpremise-cluster.git
git checkout $RELEASE
mkdir -p $OMLDIR
cp files/docker-compose.yml $OMLDIR
cp files/redis-service /etc/systemd/system

if ["$INSTALL_DOCKER" == "TRUE"]
then
chmod +x ./files/install_docker.sh 
./files/install_docker.sh
fi

cd $OMLDIR/redis
docker-compose up -d

reboot
