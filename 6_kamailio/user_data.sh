#!/bin/bash

REPO_URL=https://github.com/psychedelicto/omnileads-onpremise-cluster.git
REPO_RELEASE=onpre-001-oml-2-punto-0

export SRC=/usr/src
export COMPONENT_REPO=https://gitlab.com/omnileads/omlkamailio.git
export COMPONENT_RELEASE=omlkam-001-ajustes-fabi-temp

export NIC=enp0s3
export PRIVATE_IPV4=$(ip addr show $PRIVATE_NIC | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)
export REDIS_HOST=192.168.95.210
export REDIS_PORT=6379
export ASTERISK_HOST=192.168.95.201
export RTPENGINE_HOST=192.168.95.211
export KAMAILIO_SHM_SIZE=64
export KAMAILIO_PKG_SIZE=8

yum -y install git
cd $SRC
git clone $REPO_URL
cd omnileads-onpremise-cluster
git checkout $REPO_RELEASE
chmod +x 6_kamailio/kamailio_install.sh
./6_kamailio/kamailio_install.sh

rm -rf $SRC/omnileads-onpremise-cluster
rm -rf $SRC/omlkamailio
