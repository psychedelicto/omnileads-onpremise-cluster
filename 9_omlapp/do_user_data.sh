#!/bin/bash

PUBLIC_IPV4=$(curl -s http://169.254.169.254/metadata/v1/interfaces/public/0/ipv4/address)
PRIVATE_IPV4=$(curl -s http://169.254.169.254/metadata/v1/interfaces/private/0/ipv4/address)

REPO_URL=https://github.com/psychedelicto/omnileads-onpremise-cluster.git
REPO_RELEASE=develop

export COMPONENT_REPO=https://gitlab.com/omnileads/ominicontacto.git
export COMPONENT_RELEASE=master
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

# export PG_HOST=
# export PG_PORT=
# export KAMAILIO_HOST=
# export RTPENGINE_HOST=
# export ASTERISK_HOST=
# export REDIS_HOST=
# export DIALER_HOST=
# export MYSQL_HOST=
# export WEBSOCKET_HOST=

export ENVIRONMENT_INIT=true

################## UNCOMMENT only if you work with OML-2.0 #####################
if [[ "$COMPONENT_RELEASE" == "oml-1777-epica-separacion-componentes-oml" ]]; then
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

echo "******************************* agregados ***********************************************************"
echo "******************************* agregados ***********************************************************"
/opt/omnileads/bin/manage.sh inicializar_entorno
echo "OPTIONS="-i $PUBLIC_IPV4  -o 60 -a 3600 -d 30 -s 120 -n 127.0.0.1:22222 -m 20000 -M 50000 -L 7 --log-facility=local1""  > /etc/rtpengine-config.conf

reboot
