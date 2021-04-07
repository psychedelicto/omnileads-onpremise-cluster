#!/bin/bash

yum install epel-release git ipcalc -y

export NIC=eth0
export RELEASE=develop

export OML_DB_NAME=omnileads
export OML_USERNAME=omnileads
export OML_PASSWORD=098098ZZZ

export IPADDR_IPV4=$(ip addr show $NIC | grep "inet\b" | awk '{print $2}')
export NETADDR_IPV4=$(ipcalc -n $IPADDR_IPV4 |cut -d = -f 2)
export NETMASK_PREFIX=$(ip addr show $NIC | grep "inet\b" | awk '{print $2}' | cut -d/ -f2)


systemctl stop firewalld
systemctl disable firewalld

cd /usr/src
git clone https://github.com/psychedelicto/omnileads-onpremise-cluster.git
cd omnileads-onpremise-cluster
git checkout develop
chmod +x postgres/postgresql.sh
./postgres/postgresql.sh
