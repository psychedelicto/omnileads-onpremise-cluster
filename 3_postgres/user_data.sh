#!/bin/bash

REPO_URL=https://github.com/psychedelicto/omnileads-onpremise-cluster.git
REPO_RELEASE=onpre-001-oml-2-punto-0

export COMPONENT_REPO=https://gitlab.com/omnileads/omlrtpengine.git
export COMPONENT_RELEASE=develop

export NIC=enp0s3
export SRC=/usr/src
export OML_DB_NAME=omnileads
export OML_USERNAME=omnileads
export OML_PASSWORD=my_very_strong_pass

yum install epel-release git ipcalc -y

export IPADDR_MASK=$(ip addr show $NIC | grep "inet\b" | awk '{print $2}')
export NETADDR_IPV4=$(ipcalc -n $IPADDR_MASK |cut -d = -f 2)
export NETMASK_PREFIX=$(ip addr show $NIC | grep "inet\b" | awk '{print $2}' | cut -d/ -f2)

git clone $REPO_URL
cd omnileads-onpremise-cluster
git checkout $REPO_RELEASE
chmod +x 3_postgres/postgres_install.sh
./3_postgres/postgres_install.sh

reboot
