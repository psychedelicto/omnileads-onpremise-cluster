#!/bin/bash

echo "******************** prereq selinux and firewalld ***************************"
echo "******************** prereq selinux and firewalld ***************************"
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/sysconfig/selinux
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config
setenforce 0

systemctl disable firewalld > /dev/null 2>&1

echo "******************** yum install mariaDB ***************************"
echo "******************** yum install mariaDB ***************************"
yum install mariadb-server -y
systemctl start mariadb
systemctl enable mariadb

echo "******************** postinstall configuration ***************************"
echo "******************** postinstall configuration ***************************"
mysql -e "GRANT ALL ON *.* to '$DIALER_USER'@'$LAN_ADDRESS' IDENTIFIED BY '$DIALER_PASS' WITH GRANT OPTION;"
