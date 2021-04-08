#!/bin/bash

REPO_URL=https://github.com/psychedelicto/omnileads-onpremise-cluster.git
REPO_RELEASE=onpre-001-oml-2-punto-0

NIC=*****your_interface_network******

export SRC=/usr/src
export PRIVATE_IPV4=$(ip addr show $NIC | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)
export REDIS_PORT=40722
export COMPONENT_REPO=https://gitlab.com/omnileads/omlredis.git
export COMPONENT_RELEASE=develop

cd $SRC
yum -y install git
git clone $REPO_URL
cd omnileads-onpremise-cluster
git checkout $REPO_RELEASE
chmod +x 1_redis/redis_install.sh
./1_redis/redis_install.sh
