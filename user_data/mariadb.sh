#!/bin/bash

echo "******************** prereq selinux and firewalld ***************************"
echo "******************** prereq selinux and firewalld ***************************"
systemctl disable firewalld

echo "******************** yum install mariaDB ***************************"
echo "******************** yum install mariaDB ***************************"
yum install mariadb-server -y
systemctl start mariadb
systemctl enable mariadb

echo "******************** postinstall configuration ***************************"
echo "******************** postinstall configuration ***************************"
mysql -e "GRANT ALL ON *.* to '${mysql_username}'@'%' IDENTIFIED BY '${mysql_password}' WITH GRANT OPTION;"

reboot
