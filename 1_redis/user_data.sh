#!/bin/bash

REPO_URL=https://github.com/psychedelicto/omnileads-onpremise-cluster.git
REPO_RELEASE=develop

NIC=*****your_interface_network******

export SRC=/usr/src
export PRIVATE_IPV4=$(ip addr show $NIC | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)
export REDIS_PORT=6379
export COMPONENT_REPO=https://gitlab.com/omnileads/omlredis.git
export COMPONENT_RELEASE=develop

echo "************************ disable SElinux & firewalld *************************"
echo "************************ disable SElinux & firewalld *************************"
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/sysconfig/selinux
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config
setenforce 0
systemctl disable firewalld > /dev/null 2>&1
systemctl stop firewalld > /dev/null 2>&1

echo "************************ yum install  *************************"
echo "************************ yum install  *************************"
yum -y install python3 python3-pip epel-release git

echo "************************ Clone repo and run component install  *************************"
echo "************************ Clone repo and run component install  *************************"
cd $SRC
git clone $REPO_URL
cd omnileads-onpremise-cluster
git checkout $REPO_RELEASE
chmod +x 1_redis/redis_install.sh
./1_redis/redis_install.sh

echo "************************ Remove source dirs  *************************"
echo "************************ Remove source dirs  *************************"
rm -rf $SRC/omnileads-onpremise-cluster
rm -rf $SRC/omlredis
