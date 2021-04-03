#!/bin/bash

RELEASE=develop
SRC=/usr/src

echo "************************ install ansible *************************"
echo "************************ install ansible *************************"
echo "************************ install ansible *************************"
yum update -y
yum install python3 python3-pip epel-release git ipcalc -y
pip3 install pip --upgrade
pip3 install 'ansible==2.9.2'
export PATH="$HOME/.local/bin/:$PATH"

echo "************************ disable SElinux *************************"
echo "************************ disable SElinux *************************"
echo "************************ disable SElinux *************************"
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/sysconfig/selinux
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config
setenforce 0


echo "************************ clone REPO *************************"
echo "************************ clone REPO *************************"
echo "************************ clone REPO *************************"
cd $SRC && git clone https://gitlab.com/omnileads/omlpgsql.git
cd omlpgsql
git checkout $RELEASE
cd ansible

echo "************************ config and install *************************"
echo "************************ config and install *************************"
echo "************************ config and install *************************"
sed -i "s/postgres_database=my_database/postgres_database=$OML_DB_NAME/g" ./inventory
sed -i "s/postgres_user=my_user/postgres_user=$OML_USERNAME/g" ./inventory
sed -i "s/postgres_password=my_very_strong_pass/postgres_password=$OML_PASSWORD/g" ./inventory
sed -i "s/subnet=X.X.X.X\/XX/subnet=$NETADDR_IPV4\/$NETMASK_PREFIX/g" ./inventory

ansible-playbook postgresql.yml -i inventory --extra-vars "postgresql_version=$(cat ../.postgresql_version)"
