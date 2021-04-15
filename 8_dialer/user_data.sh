#!/bin/bash

REPO_URL=https://github.com/psychedelicto/omnileads-onpremise-cluster.git
REPO_RELEASE=onpre-001-oml-2-punto-0

export MYSQL_HOST=192.168.95.215
export MYSQL_DB=wombat
export MYSQL_USER=wombat
export MYSQL_PASS=C11H15NO2

echo "******************** prereq selinux and firewalld ***************************"
echo "******************** prereq selinux and firewalld ***************************"
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/sysconfig/selinux
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config
setenforce 0
systemctl disable firewalld > /dev/null 2>&1
systemctl stop firewalld > /dev/null 2>&1


yum -y install git wget
cd $SRC
git clone $REPO_URL
cd omnileads-onpremise-cluster
git checkout $REPO_RELEASE

if [[ "$MYSQL_HOST" == "localhost" ]]
then
  chmod +x ./7_mariadb/user_data.sh
  sh ./7_mariadb/user_data.sh
fi

chmod +x ./8_dialer/dialer.sh
sh ./8_dialer/dialer.sh
