#!/bin/bash

mysql_username=$1
mysql_password=$2
DIALER_HOST=$3

echo "******************** prereq selinux and firewalld ***************************"
echo "******************** prereq selinux and firewalld ***************************"
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/sysconfig/selinux
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config
systemctl disable firewalld
setenforce 0

echo "******************** yum install mariaDB ***************************"
echo "******************** yum install mariaDB ***************************"
yum install mariadb-server -y
systemctl start mariadb
systemctl enable mariadb

echo "******************** postinstall configuration ***************************"
echo "******************** postinstall configuration ***************************"
mysql -e "GRANT ALL ON *.* to '$mysql_username'@'$DIALER_HOST' IDENTIFIED BY '$mysql_password' WITH GRANT OPTION;"
