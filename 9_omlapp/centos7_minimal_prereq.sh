#!/bin/bash

REPO_URL=https://github.com/psychedelicto/omnileads-onpremise-cluster.git
REPO_RELEASE=onpre-001-oml-2-punto-0

############### CentOS-7 and OMNILEADS env settings #############################
systemctl stop firewalld
systemctl disable firewalld
#################################################################################

export COMPONENT_REPO=https://gitlab.com/omnileads/ominicontacto.git
export COMPONENT_RELEASE=master
export SRC=/usr/src

export NIC=enp0s3
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

#export OML_2=true

#export PG_HOST=
#export PG_PORT=
#export KAMAILIO_HOST=
#export RTPENGINE_HOST=
#export ASTERISK_HOST=
#export REDIS_HOST=
#export DIALER_HOST=
#export MYSQL_HOST=
#export WEBSOCKET_HOST=

#export ENVIRONMENT_INIT=true

yum -y install git
git clone $REPO_URL
cd omnileads-onpremise-cluster
git checkout $REPO_RELEASE
chmod +x omlapp/omlapp_install.sh
./omlapp/omlapp_install.sh

rm -rf $SRC/omnileads-onpremise-cluster
