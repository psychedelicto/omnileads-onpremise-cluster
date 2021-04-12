#!/bin/bash

REPO_URL=https://github.com/psychedelicto/omnileads-onpremise-cluster.git
REPO_RELEASE=onpre-001-oml-2-punto-0

echo "************************ disable SElinux *************************"
echo "************************ disable SElinux *************************"
echo "************************ disable SElinux *************************"
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/sysconfig/selinux
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config
setenforce 0
systemctl disable firewalld > /dev/null 2>&1
systemctl stop firewalld > /dev/null 2>&1

export SRC=/usr/src
export COMPONENT_REPO=https://gitlab.com/omnileads/omnileads-websockets.git
export COMPONENT_RELEASE=develop

export REDIS_HOST=192.168.95.201
export REDIS_PORT=6379
export WEBSOCKET_PORT=8000

echo "************************ yum install *************************"
echo "************************ yum install *************************"
yum install -y epel-release git python3 python3-pip

echo "************************ Clone repo and run component install  *************************"
echo "************************ Clone repo and run component install  *************************"
cd $SRC
git clone $REPO_URL
cd omnileads-onpremise-cluster
git checkout $REPO_RELEASE
chmod +x 4_websockets/websockets_install.sh
./4_websockets/websockets_install.sh

echo "************************ Remove source dirs  *************************"
echo "************************ Remove source dirs  *************************"
rm -rf $SRC/omnileads-onpremise-cluster
rm -rf $SRC/omnileads-websockets
