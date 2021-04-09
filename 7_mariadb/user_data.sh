#!/bin/bash

REPO_URL=https://github.com/psychedelicto/omnileads-onpremise-cluster.git
REPO_RELEASE=onpre-001-oml-2-punto-0

export NIC=enp0s3
export PRIVATE_IPV4=$(ip addr show $PRIVATE_NIC | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)
export DIALER_HOST=192.168.95.215
export DIALER_USER=wombat
export DIALER_PASS=C11H15NO2

yum -y install git
cd $SRC
git clone $REPO_URL
cd omnileads-onpremise-cluster
git checkout $REPO_RELEASE
chmod +x 7_mariadb/mariadb_install.sh
sh ./7_mariadb/mariadb_install.sh

rm -rf $SRC/omnileads-onpremise-cluster
