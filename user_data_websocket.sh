#!/bin/bash

SRC=/usr/src
COMPONENT_REPO=https://gitlab.com/omnileads/omnileads-websockets.git
COMPONENT_RELEASE=develop
COMPONENT_REPO_DIR=omlacd

# Set your redis host
REDIS_HOST=${redis_host}
REDIS_PORT=6379
WEBSOCKET_PORT=8000

echo "************************ disable SElinux *************************"
echo "************************ disable SElinux *************************"
echo "************************ disable SElinux *************************"
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/sysconfig/selinux
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config
setenforce 0
systemctl disable firewalld > /dev/null 2>&1
systemctl stop firewalld > /dev/null 2>&1

echo "************************ yum install *************************"
echo "************************ yum install *************************"
echo "************************ yum install *************************"
yum install -y epel-release git python3 python3-pip

echo "************************ install ansible *************************"
echo "************************ install ansible *************************"
echo "************************ install ansible *************************"
pip3 install pip --upgrade
pip3 install 'ansible==2.9.2'
export PATH="$HOME/.local/bin/:$PATH"

echo "************************ clone REPO *************************"
echo "************************ clone REPO *************************"
echo "************************ clone REPO *************************"
cd $SRC
git clone $COMPONENT_REPO
cd omnileads-websockets
git checkout $COMPONENT_RELEASE
cd deploy

echo "******************** Install websocket ***************************"
echo "******************** Install websocket ***************************"
echo "******************** Install websocket ***************************"
sed -i "s/redis_host=/redis_host=$REDIS_HOST/g" ./inventory
sed -i "s/redis_port=/redis_port=$REDIS_PORT/g" ./inventory
sed -i "s/websocket_port=8000/websocket_port=$WEBSOCKET_PORT/g" ./inventory

ansible-playbook websockets.yml -i inventory --extra-vars "websockets_version=$(cat ../.websockets_version)"

echo "************************ Remove source dirs  *************************"
echo "************************ Remove source dirs  *************************"
echo "************************ Remove source dirs  *************************"
rm -rf $SRC/omnileads-websockets
