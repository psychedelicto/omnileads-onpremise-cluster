#!/bin/bash

REPO_URL=https://github.com/psychedelicto/omnileads-onpremise-cluster.git
REPO_BRANCH=onpre-001-oml-2-punto-0

# if you have only one interface then use this in both fields (example eth0)
PRIVATE_NIC=*****your_private_interface_network******
PUBLIC_NIC=*****your_public_interface_network******

export COMPONENT_REPO=https://gitlab.com/omnileads/omlrtpengine.git
export COMPONENT_RELEASE=develop
export SRC=/usr/src

export PRIVATE_IPV4=$(ip addr show $PRIVATE_NIC | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)
export PUBLIC_IPV4=$(ip addr show $PUBLIC_NIC | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)

export EXTERN_IP=none

cd $SRC
yum -y install git
git clone $REPO_URL
cd omnileads-onpremise-cluster
git checkout $REPO_BRANCH
chmod +x 2_rtpengine/rtpengine_install.sh
./2_rtpengine/rtpengine_install.sh
