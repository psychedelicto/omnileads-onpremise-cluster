#!/bin/bash

CLOUD=******set your cloud environment******
#CLOUD=digitalocean
#CLOUD=onpremise
#CLOUD=linode
#CLOUD=vultr

# Set your net interfaces, you must have at least a PRIVATE_NIC
# The public interface is not mandatory, if you don't have it, you can leave it blank
PRIVATE_NIC=${NIC}
REDIS_PORT=6379

SRC=/usr/src
COMPONENT_REPO=https://gitlab.com/omnileads/omlredis.git
COMPONENT_RELEASE=develop

echo "******************** IPV4 address config ***************************"
echo "******************** IPV4 address config ***************************"
case $CLOUD in
  digitalocean)
    echo -n "DigitalOcean"
    PUBLIC_IPV4=$(curl -s http://169.254.169.254/metadata/v1/interfaces/public/0/ipv4/address)
    PRIVATE_IPV4=$(curl -s http://169.254.169.254/metadata/v1/interfaces/private/0/ipv4/address)
    ;;
  linode)
    echo -n "Linode"
    PRIVATE_IPV4=$(ip addr show $NIC |grep "inet 192.168" |awk '{print $2}' | cut -d/ -f1)
    PUBLIC_IPV4=$(curl checkip.amazonaws.com)
    ;;
  onpremise)
    echo -n "Onpremise CentOS7 Minimal"
    PRIVATE_IPV4=$(ip addr show $PRIVATE_NIC | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)
    if [ $PUBLIC_NIC ]; then
      PUBLIC_IPV4=$(ip addr show $PUBLIC_NIC | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)
    else
      PUBLIC_IPV4=$(curl ifconfig.co)
    fi
    ;;
  *)
    echo -n "you must to declare CLOUD variable"
    ;;
esac

echo "************************ disable SElinux & firewalld *************************"
echo "************************ disable SElinux & firewalld *************************"
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/sysconfig/selinux
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config
setenforce 0
systemctl disable firewalld > /dev/null 2>&1
systemctl stop firewalld > /dev/null 2>&1

echo "************************ yum install  *************************"
echo "************************ yum install  *************************"
yum -y install python3 python3-pip epel-release git

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

echo "************************ Remove source dirs  *************************"
echo "************************ Remove source dirs  *************************"
rm -rf $SRC/omlredis
