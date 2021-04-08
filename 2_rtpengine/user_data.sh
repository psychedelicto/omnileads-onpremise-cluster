#!/bin/bash

REPO_URL=https://github.com/psychedelicto/omnileads-onpremise-cluster.git
REPO_BRANCH=onpre-001-oml-2-punto-0

# Set your net interfaces, you must have at least a PRIVATE_NIC
# The public interface is not mandatory, if you don't have it, you can leave it blank
PRIVATE_NIC=
PUBLIC_NIC=

export COMPONENT_REPO=https://gitlab.com/omnileads/omlrtpengine.git
export COMPONENT_RELEASE=develop
export SRC=/usr/src

########################################## SCENARIO #######################################
# You must to define your scenario to deploy RTPEngine
# LAN if all agents work on LAN netwrok or VPN
# CLOUD if all agents work from the WAN
# HYBRID_1_NIC if some agents work on LAN and others from WAN and the host have ony 1 NIC
# HYBRID_1_NIC if some agents work on LAN and others from WAN and the host have 2 NICs
# (1 NIC for LAN IPADDR and 1 NIC for WAN IPADDR)
export SCENARIO=LAN
###########################################################################################

export PRIVATE_IPV4=$(ip addr show $PRIVATE_NIC | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)

if [ $PUBLIC_NIC ]; then
export PUBLIC_IPV4=$(ip addr show $PUBLIC_NIC | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)
else
export PUBLIC_IPV4=$(curl ifconfig.co)
fi

cd $SRC
yum -y install git
git clone $REPO_URL
cd omnileads-onpremise-cluster
git checkout $REPO_BRANCH
chmod +x 2_rtpengine/rtpengine_install.sh
./2_rtpengine/rtpengine_install.sh

rm -rf $SRC/omnileads-onpremise-cluster
rm -rf $SRC/omlrtpengine
