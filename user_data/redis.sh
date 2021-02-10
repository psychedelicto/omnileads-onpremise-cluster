#!/bin/bash

OMLCOMP=redis
RELEASE=main
OMLDIR=/opt/omnileads/
INSTALL_DOCKER=TRUE

cd /var/tmp
git clone https://github.com/psychedelicto/omnileads-onpremise-cluster.git
cd omnileads-onpremise-cluster
git checkout $RELEASE

mkdir -p $OMLDIR/$OMLCOMP
cp files/docker-compose.yml $OMLDIR/$OMLCOMP
cp files/redis.service /etc/systemd/system

if [[ "$INSTALL_DOCKER" == "TRUE" ]]
then
chmod +x ./files/install_docker.sh
cd ./files
sh install_docker.sh
fi

cd $OMLDIR/$OMLCOMP
docker-compose up -d
