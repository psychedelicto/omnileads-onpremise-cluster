#!/bin/bash

REPO_URL=https://github.com/psychedelicto/omnileads-onpremise-cluster.git
REPO_BRANCH=develop

export COMPONENT_REPO=https://gitlab.com/omnileads/omlrtpengine.git
export COMPONENT_RELEASE=develop
export SRC=/usr/src

yum update -y && yum install git python3-pip python3 kernel-devel curl -y

########################################## SCENARIO #######################################
# You must to define your scenario to deploy RTPEngine
# LAN if all agents work on LAN netwrok or VPN
# CLOUD if all agents work from the WAN
# HYBRID_1_NIC if some agents work on LAN and others from WAN and the host have ony 1 NIC
# HYBRID_1_NIC if some agents work on LAN and others from WAN and the host have 2 NICs
# (1 NIC for LAN IPADDR and 1 NIC for WAN IPADDR)
export SCENARIO=LAN
###########################################################################################

export PUBLIC_IPV4=$(curl -s http://169.254.169.254/metadata/v1/interfaces/public/0/ipv4/address)
export PRIVATE_IPV4=$(curl -s http://169.254.169.254/metadata/v1/interfaces/private/0/ipv4/address)

echo "******************** prereq selinux and firewalld ***************************"
echo "******************** prereq selinux and firewalld ***************************"
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/sysconfig/selinux
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config
setenforce 0

echo "************************ Clone repo and run component install  *************************"
echo "************************ Clone repo and run component install  *************************"
cd $SRC
git clone $REPO_URL
cd omnileads-onpremise-cluster
git checkout $REPO_BRANCH
chmod +x 2_rtpengine/rtpengine_install.sh
./2_rtpengine/rtpengine_install.sh

echo "************************ Remove source dirs  *************************"
echo "************************ Remove source dirs  *************************"
rm -rf $SRC/omnileads-onpremise-cluster
rm -rf $SRC/omlrtpengine
