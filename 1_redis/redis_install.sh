#!/bin/bash

echo "************************ install ansible *************************"
echo "************************ install ansible *************************"
echo "************************ install ansible *************************"
yum install python3 python3-pip epel-release git -y
pip3 install pip --upgrade
pip3 install 'ansible==2.9.2'
export PATH="$HOME/.local/bin/:$PATH"

echo "************************ disable SElinux *************************"
echo "************************ disable SElinux *************************"
echo "************************ disable SElinux *************************"
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/sysconfig/selinux
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config
setenforce 0

FIREWALLD=$(yum list installed |grep firewalld)
if [ $FIREWALLD ]; then
  systemctl stop firewalld
  systemctl disable firewalld
fi

echo "************************ clone REPO *************************"
echo "************************ clone REPO *************************"
echo "************************ clone REPO *************************"
cd $SRC
git clone $COMPONENT_REPO
cd omlredis
git checkout $COMPONENT_RELEASE
cd deploy

echo "************************ config and install *************************"
echo "************************ config and install *************************"
echo "************************ config and install *************************"

ansible-playbook redis.yml -i inventory --extra-vars "redis_version=$(cat ../.redis_version) redisgears_version=$(cat ../.redisgears_version)"

sed -i "s/#bind/bind $PRIVATE_IPV4/g" /etc/redis.conf
sed -i "s/port 6379/port $REDIS_PORT/g" /etc/redis.conf

systemctl restart redis
