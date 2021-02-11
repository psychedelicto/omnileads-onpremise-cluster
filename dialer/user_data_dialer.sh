#!/bin/bash

RELEASE=main
OMLCOMP=dialer
OMLDIR=/opt/omnileads/

mysql_host=localhost
mysql_database=wombat
mysql_username=wombat
mysql_password=admin123

yum install -y git

cd /var/tmp
git clone https://github.com/psychedelicto/omnileads-onpremise-cluster.git
cd omnileads-onpremise-cluster
git checkout $RELEASE

if [[ "$mysql_host" == "localhost" ]]
then
chmod +x ./mariadb/mariadb.sh
sh ./mariadb/mariadb.sh $mysql_username $mysql_password
fi
chmod +x ./dialer/files/dialer.sh
sh ./dialer/files/dialer.sh $mysql_host $mysql_database $mysql_username $mysql_password

reboot
