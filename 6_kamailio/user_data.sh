#!/bin/bash

REPO_URL=https://github.com/psychedelicto/omnileads-onpremise-cluster.git
REPO_RELEASE=develop

echo "************************ disable SElinux *************************"
echo "************************ disable SElinux *************************"
echo "************************ disable SElinux *************************"
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/sysconfig/selinux
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config
setenforce 0
systemctl disable firewalld > /dev/null 2>&1
systemctl stop firewalld > /dev/null 2>&1

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

echo "************************ yum install  *************************"
echo "************************ yum install  *************************"
yum install -y python3 python3-pip epel-release git -y

echo "************************ Clone repo and run component install  *************************"
echo "************************ Clone repo and run component install  *************************"
cd $SRC
git clone $REPO_URL
cd omnileads-onpremise-cluster
git checkout $REPO_RELEASE
chmod +x 6_kamailio/kamailio_install.sh
./6_kamailio/kamailio_install.sh

echo "********************************** sngrep SIP sniffer install *********************************"
echo "********************************** sngrep SIP sniffer install *********************************"
yum install ncurses-devel make libpcap-devel pcre-devel \
openssl-devel git gcc autoconf automake -y
cd $SRC && git clone https://github.com/irontec/sngrep
cd sngrep && ./bootstrap.sh && ./configure && make && make install
ln -s /usr/local/bin/sngrep /usr/bin/sngrep

echo "************************ Remove source dirs  *************************"
echo "************************ Remove source dirs  *************************"
rm -rf $SRC/omnileads-onpremise-cluster
rm -rf $SRC/omlkamailio
