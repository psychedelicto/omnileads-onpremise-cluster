#!/bin/bash

REPO_URL=https://github.com/psychedelicto/omnileads-onpremise-cluster.git
REPO_RELEASE=onpre-001-oml-2-punto-0
NIC=enp0s3

############### CentOS-7 and OMNILEADS env settings #############################
systemctl stop firewalld
systemctl disable firewalld
#################################################################################

export NIC=$NIC
export RELEASE=release-1.14.0

export TZ="America/Argentina/Cordoba"
export sca=1800
export ami_user=omnileadsami
export ami_password=5_MeO_DMT
export dialer_user=demoadmin
export dialer_password=demo
export pg_database=omnileads
export pg_username=omnileads
export pg_password=my_very_strong_pass
export extern_ip=none

#export PG_HOST=
#export PG_PORT=
#export KAMAILIO_HOST=
#export RTPENGINE_HOST=
#export ASTERISK_HOST=
#export REDIS_HOST=
#export DIALER_HOST=
#export MYSQL_HOST=

yum -y install git
git clone $REPO_URL
cd omnileads-onpremise-cluster
git checkout $REPO_RELEASE
chmod +x omlapp/omlapp_install.sh
./omlapp/omlapp_install.sh

reboot
