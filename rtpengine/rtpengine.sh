#!/bin/bash

RELEASE=$1

SRC=/usr/src

echo "************************* yum update and install kernel-devel ***********************************"
echo "************************* yum update and install kernel-devel ***********************************"
yum update -y && yum install git python3-pip python3 -y
pip3 install pip --upgrade
pip3 install 'ansible==2.9.2'

echo "******************** prereq selinux and firewalld ***************************"
echo "******************** prereq selinux and firewalld ***************************"
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/sysconfig/selinux
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config
setenforce 0

echo "******************** Install rtpengine ***************************"
echo "******************** Install rtpengine ***************************"
cd $SRC
git clone https://gitlab.com/omnileads/omlrtpengine.git
cd omlrtpengine
git checkout $RELEASE
cd deploy
ansible-playbook rtpengine.yml -i inventory --extra-vars "iface=eth0 rtpengine_version=$(cat ../.rtpengine_version)"

echo "******************** Overwrite rtpengine.conf ***************************"
echo "******************** Overwrite rtpengine.conf ***************************"
  echo "OPTIONS="-i $PUBLIC_IPV4  -o 60 -a 3600 -d 30 -s 120 -n $PRIVATE_IPV4:22222 -m 20000 -M 50000 -L 7 --log-facility=local1""  > /etc/rtpengine-config.conf

reboot