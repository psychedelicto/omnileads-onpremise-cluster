#!/bin/bash

CLOUD=******set your cloud environment******
#CLOUD=digitalocean
#CLOUD=onpremise
#CLOUD=linode
#CLOUD=vultr

# Set your net interfaces, you must have at least a PRIVATE_NIC
# The public interface is not mandatory, if you don't have it, you can leave it blank
NIC=${NIC}

COMPONENT_REPO=https://gitlab.com/omnileads/omlpgsql.git
COMPONENT_RELEASE=develop

SOURCE_DIR=/usr/src

# set your own variables
OMLAPP_DB_NAME=${database_name}
OMLAPP_USERNAME=${omlapp_user}
OMLAPP_PASSWORD=${omlapp_password}

echo "************************ yum install *************************"
echo "************************ yum install *************************"
yum install -y python3 python3-pip epel-release git ipcalc

echo "******************** IPV4 address config ***************************"
echo "******************** IPV4 address config ***************************"
case $CLOUD in
  digitalocean)
    echo -n "DigitalOcean"
     PUBLIC_IPV4=$(curl -s http://169.254.169.254/metadata/v1/interfaces/public/0/ipv4/address)
     PRIVATE_IPV4=$(curl -s http://169.254.169.254/metadata/v1/interfaces/private/0/ipv4/address)
     PRIVATE_NETMASK=$(curl -s http://169.254.169.254/metadata/v1/interfaces/private/0/ipv4/netmask)
     NETADDR_IPV4=$(ipcalc -n $PRIVATE_IPV4 $PRIVATE_NETMASK |cut -d = -f 2)
     NETMASK_PREFIX=$(ipcalc -p $PRIVATE_IPV4 $PRIVATE_NETMASK |cut -d = -f 2)
    ;;
  linode)
    echo -n "Linode"
     IPADDR_MASK=$(ip addr show $NIC | grep "192.168" | awk '{print $2}')
     NETADDR_IPV4=$(ipcalc -n $IPADDR_MASK |cut -d = -f 2)
     NETMASK_PREFIX=$(ip addr show $NIC | grep "192.168" | awk '{print $2}' | cut -d/ -f2)
    ;;
  onpremise)
    echo -n "Onpremise CentOS7 Minimal"
     IPADDR_MASK=$(ip addr show $NIC | grep "inet\b" | awk '{print $2}')
     NETADDR_IPV4=$(ipcalc -n $IPADDR_MASK |cut -d = -f 2)
     NETMASK_PREFIX=$(ip addr show $NIC | grep "inet\b" | awk '{print $2}' | cut -d/ -f2)
    ;;
  *)
    echo -n "you must to declare CLOUD variable"
    ;;
esac

echo -n "********* NETADDR: $NETADDR_IPV4 & ************ NETMASK: $NETMASK_PREFIX"
sleep 3

echo "************************ install ansible *************************"
echo "************************ install ansible *************************"
echo "************************ install ansible *************************"
pip3 install pip --upgrade
pip3 install 'ansible==2.9.2'
export PATH="$HOME/.local/bin/:$PATH"

echo "************************ disable SElinux *************************"
echo "************************ disable SElinux *************************"
echo "************************ disable SElinux *************************"
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/sysconfig/selinux
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config
setenforce 0
systemctl disable firewalld > /dev/null 2>&1
systemctl stop firewalld > /dev/null 2>&1

echo "************************ clone REPO *************************"
echo "************************ clone REPO *************************"
echo "************************ clone REPO *************************"
cd $SOURCE_DIR
git clone $COMPONENT_REPO
cd omlpgsql
git checkout $COMPONENT_RELEASE
cd deploy

echo "************************ config and install *************************"
echo "************************ config and install *************************"
echo "************************ config and install *************************"
sed -i "s/postgres_database=my_database/postgres_database=$OMLAPP_DB_NAME/g" ./inventory
sed -i "s/postgres_user=my_user/postgres_user=$OMLAPP_USERNAME/g" ./inventory
sed -i "s/postgres_password=my_very_strong_pass/postgres_password=$OMLAPP_PASSWORD/g" ./inventory
sed -i "s/subnet=X.X.X.X\/XX/subnet=$NETADDR_IPV4\/$NETMASK_PREFIX/g" ./inventory

ansible-playbook postgresql.yml -i inventory --extra-vars "postgresql_version=$(cat ../.postgresql_version)"

systemctl restart postgresql-11
