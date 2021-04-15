#!/bin/bash

echo "******************** yum install mariaDB ***************************"
echo "******************** yum install mariaDB ***************************"
yum install mariadb-server -y
systemctl start mariadb
systemctl enable mariadb

echo "******************** postinstall configuration ***************************"
echo "******************** postinstall configuration ***************************"
mysql -e "GRANT ALL ON *.* to '$DIALER_USER'@'$LAN_ADDRESS' IDENTIFIED BY '$DIALER_PASS' WITH GRANT OPTION;"
