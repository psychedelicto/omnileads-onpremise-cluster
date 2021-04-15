#!/bin/bash

PUBLIC_IPV4=$(curl -s http://169.254.169.254/metadata/v1/interfaces/public/0/ipv4/address)
PRIVATE_IPV4=$(curl -s http://169.254.169.254/metadata/v1/interfaces/private/0/ipv4/address)

REPO_URL=https://github.com/psychedelicto/omnileads-onpremise-cluster.git
REPO_RELEASE=develop

export COMPONENT_REPO=https://gitlab.com/omnileads/ominicontacto.git
export COMPONENT_RELEASE=${omnileads_release}
export SRC=/usr/src

export NIC=eth1
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

if [[ "${pg_host}" != "NULL" ]]; then
export PG_HOST=${pg_host}
fi
if [[ "${pg_port}" != "NULL" ]]; then
export PG_PORT=${pg_port}
fi
if [[ "${kamailio_host}" != "NULL" ]]; then
export KAMAILIO_HOST=${kamailio_host}
fi
if [[ "${rtpengine_host}" != "NULL" ]]; then
export RTPENGINE_HOST=${rtpengine_host}
fi
if [[ "${asterisk_host}" != "NULL" ]]; then
export ASTERISK_HOST=${asterisk_host}
fi
if [[ "${redis_host}" != "NULL" ]]; then
export REDIS_HOST=${redis_host}
fi
if [[ "${dialer_host}" != "NULL" ]]; then
export DIALER_HOST=${dialer_host}
fi
if [[ "${mysql_host}" != "NULL" ]]; then
export MYSQL_HOST=${mysql_host}
fi
if [[ "${websocket_host}" != "NULL" ]]; then
export WEBSOCKET_HOST=${websocket_host}
fi

export ENVIRONMENT_INIT=true

################## UNCOMMENT only if you work with OML-2.0 #####################
if [[ "${omnileads_release}" == "oml-1777-epica-separacion-componentes-oml" ]]; then
  export OML_2=true
  export KAMAILIO_BRANCH=develop
  export ASTERISK_BRANCH=develop
  export RTPENGINE_BRANCH=develop
  export NGINX_BRANCH=develop
  export REDIS_BRANCH=develop
  export POSTGRES_BRANCH=develop
  export WEBSOCKET_BRANCH=develop
fi
################################################################################

echo "******************** SElinux disable ***************************"
echo "******************** SElinux disable ***************************"
setenforce 0
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/sysconfig/selinux
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config

echo  "**********Digital Ocean and OMniLeads /etc/hosts config *********************"
echo  "**********Digital Ocean and OMniLeads /etc/hosts config *********************"
sed -i 's/127.0.0.1 '$(hostname)'/#127.0.0.1 '$(hostname)'/' /etc/hosts
sed -i 's/::1 '$(hostname)'/#::1 '$(hostname)'/' /etc/hosts

echo "******************** yum update and install packages ***************************"
echo "******************** yum update and install packages ***************************"
yum -y update
yum -y install git python3-pip kernel-devel

echo "******************** run component install ***************************"
echo "******************** run component install ***************************"
git clone $REPO_URL
cd omnileads-onpremise-cluster
git checkout $REPO_RELEASE
chmod +x 9_omlapp/omlapp_install.sh
./9_omlapp/omlapp_install.sh

rm -rf $SRC/omnileads-onpremise-cluster

reboot
