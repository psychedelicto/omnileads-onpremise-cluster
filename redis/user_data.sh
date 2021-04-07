#!/bin/bash

NIC=eth1

REPO_URL=https://github.com/psychedelicto/omnileads-onpremise-cluster.git
REPO_RELEASE=onpre-001-oml-2-punto-0

export SRC=/usr/src
export PRIVATE_IPV4=$(ip addr show $NIC | grep "inet\b" | awk '{print $2}')
export NIC=eth1
export REDIS_PORT=6379
export COMPONENT_REPO=https://gitlab.com/omnileads/omlredis.git
export COMPONENT_RELEASE=develop

yum -y install git
git clone $REPO_URL
cd omnileads-onpremise-cluster
git checkout $REPO_RELEASE
chmod +x redis/redis_install.sh
./redis/redis_install.sh

reboot
