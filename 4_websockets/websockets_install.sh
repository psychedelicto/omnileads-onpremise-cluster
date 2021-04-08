#!/bin/bash

# You must set temporal ENVVARS PRIVATE_IPV4, NETADDR_IPV4 y NETMASK_PREFIX
# IPADDR_IPV4=$(ip addr show $NIC | grep "inet\b" | awk '{print $2}')
# NETADDR_IPV4=$(ipcalc -n $IPADDR_IPV4 |cut -d = -f 2)
# NETMASK_PREFIX=$(ip addr show $NIC | grep "inet\b" | awk '{print $2}' | cut -d/ -f2)


echo "************************ install ansible *************************"
echo "************************ install ansible *************************"
echo "************************ install ansible *************************"
yum install python3 python3-pip epel-release -y
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
git clone $COMPONENT_RELEASE
cd omnileads-websockets
git checkout $COMPONENT_RELEASE
cd deploy

echo "******************** Install websocket ***************************"
echo "******************** Install websocket ***************************"
sed -i "s/redis_host=/redis_host=$REDIS_HOST/g" ./inventory
sed -i "s/redis_port=/redis_port=$REDIS_PORT/g" ./inventory
sed -i "s/websocket_port=8000/websocket_port=$WEBSOCKET_PORT/g" ./inventory

ansible-playbook websockets.yml -i inventory --extra-vars "websockets_version=$(cat ../.websockets_version)"
