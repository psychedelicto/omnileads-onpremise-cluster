#!/bin/bash

NIC=enp0s3

yum install epel-release git ipcalc -y

export NIC=$NIC
export extern_ip=none
export RELEASE=develop

export PRIVATE_IPV4=$(ip addr show $NIC | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)
export PUBLIC_IPV4=$(ip addr show $NIC | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)

systemctl stop firewalld
systemctl disable firewalld

cd /usr/src
git clone https://github.com/psychedelicto/omnileads-onpremise-cluster.git
cd omnileads-onpremise-cluster
git checkout develop
chmod +x rtpengine/rtpengine.sh
./rtpengine/rtpengine.sh
