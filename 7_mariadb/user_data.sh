#!/bin/bash

REPO_URL=https://github.com/psychedelicto/omnileads-onpremise-cluster.git
REPO_RELEASE=onpre-001-oml-2-punto-0

NIC=enp0s3

export DIALER_USER=wombat
export DIALER_PASS=C11H15NO2

yum install -y epel-release
yum install -y git ipcalc

IPADDR_MASK=$(ip addr show $NIC | grep "inet\b" | awk '{print $2}')
NETADDR_IPV4=$(ipcalc -n $IPADDR_MASK |cut -d = -f 2)
NETMASK_PREFIX=$(ipcalc -m $IPADDR_MASK |cut -d= -f2)

export LAN_ADDRESS="$NETADDR_IPV4/$NETMASK_PREFIX"

cd $SRC
git clone $REPO_URL
cd omnileads-onpremise-cluster
git checkout $REPO_RELEASE
chmod +x 7_mariadb/mariadb_install.sh
sh ./7_mariadb/mariadb_install.sh

rm -rf $SRC/omnileads-onpremise-cluster