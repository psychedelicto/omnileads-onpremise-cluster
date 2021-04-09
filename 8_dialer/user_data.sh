#!/bin/bash

REPO_URL=https://github.com/psychedelicto/omnileads-onpremise-cluster.git
REPO_RELEASE=onpre-001-oml-2-punto-0

export MYSQL_HOST=192.168.95.215
export MYSQL_DB=wombat
export MYSQL_USER=wombat
export MYSQL_PASS=C11H15NO2

yum -y install git
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
