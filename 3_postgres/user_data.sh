#!/bin/bash

REPO_URL=https://github.com/psychedelicto/omnileads-onpremise-cluster.git
REPO_RELEASE=develop

export COMPONENT_REPO=https://gitlab.com/omnileads/omlpgsql.git
export COMPONENT_RELEASE=develop

export NIC=enp0s3
export SOURCE_DIR=/usr/src
export OMLAPP_DB_NAME=omnileads
export OMLAPP_USERNAME=omnileads
export OMLAPP_PASSWORD=my_very_strong_pass

echo "************************ yum install *************************"
echo "************************ yum install *************************"
yum install -y python3 python3-pip epel-release git ipcalc

echo "************************ Set Network config variables *************************"
echo "************************ Set Network config variables *************************"
export IPADDR_MASK=$(ip addr show $NIC | grep "inet\b" | awk '{print $2}')
export NETADDR_IPV4=$(ipcalc -n $IPADDR_MASK |cut -d = -f 2)
export NETMASK_PREFIX=$(ip addr show $NIC | grep "inet\b" | awk '{print $2}' | cut -d/ -f2)

echo "************************ disable SElinux *************************"
echo "************************ disable SElinux *************************"
echo "************************ disable SElinux *************************"
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/sysconfig/selinux
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config
setenforce 0
systemctl disable firewalld > /dev/null 2>&1
systemctl stop firewalld > /dev/null 2>&1

echo "************************ Clone repo and run component install  *************************"
echo "************************ Clone repo and run component install  *************************"
cd $SOURCE_DIR
git clone $REPO_URL
cd omnileads-onpremise-cluster
git checkout $REPO_RELEASE
chmod +x 3_postgres/postgres_install.sh
./3_postgres/postgres_install.sh

reboot
