#!/bin/bash

OMLCOMP=dialer
RELEASE=main
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
cd $OMLCOMP
sh user_data_dialer.sh $mysql_host $mysql_database $mysql_username $mysql_password

reboot
