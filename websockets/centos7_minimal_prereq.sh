#!/bin/bash

REPO_URL=https://github.com/psychedelicto/omnileads-onpremise-cluster.git
REPO_RELEASE=onpre-001-oml-2-punto-0

############### CentOS-7 and OMNILEADS env settings #############################
systemctl stop firewalld
systemctl disable firewalld
#################################################################################

export RELEASE=develop
export REDIS_HOST=192.168.95.201
export REDIS_PORT=6379
export WEBSOCKET_PORT=8000

yum -y install git
git clone $REPO_URL
cd omnileads-onpremise-cluster
git checkout $REPO_RELEASE
chmod +x websockets/websockets_install.sh
./websockets/websockets_install.sh

reboot
