#!/bin/bash

REPO_URL=https://github.com/psychedelicto/omnileads-onpremise-cluster.git
REPO_RELEASE=develop

echo "******************** Set deploy variables ***************************"
echo "******************** Set deploy variables ***************************"
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

################## UNCOMMENT only if you work with OML-2.0 #####################
#export OML_2=true

#export KAMAILIO_BRANCH=develop
#export ASTERISK_BRANCH=develop
#export RTPENGINE_BRANCH=develop
#export NGINX_BRANCH=develop
#export REDIS_BRANCH=develop
#export POSTGRES_BRANCH=develop
#export WEBSOCKET_BRANCH=develop
################################################################################


echo "******************** SElinux and Firewalld disable ***************************"
echo "******************** SElinux and Firewalld disable ***************************"
setenforce 0
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/sysconfig/selinux
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config

systemctl stop firewalld
systemctl disable firewalld

echo "******************** yum update and install packages ***************************"
echo "******************** yum update and install packages ***************************"
yum -y update && yum -y install git python3 python3-pip kernel-devel

echo "******************** run component install ***************************"
echo "******************** run component install ***************************"
git clone $REPO_URL
cd omnileads-onpremise-cluster
git checkout $REPO_RELEASE
chmod +x 9_omlapp/omlapp_install.sh
./9_omlapp/omlapp_install.sh

rm -rf $SRC/omnileads-onpremise-cluster

echo "********************************** sngrep SIP sniffer install *********************************"
echo "********************************** sngrep SIP sniffer install *********************************"
yum install ncurses-devel make libpcap-devel pcre-devel \
    openssl-devel git gcc autoconf automake -y
cd /root && git clone https://github.com/irontec/sngrep
cd sngrep && ./bootstrap.sh && ./configure && make && make install
ln -s /usr/local/bin/sngrep /usr/bin/sngrep

echo "********************************** setting demo environment *********************************"
echo "********************************** setting demo environment *********************************"
if [ "$ENVIRONMENT_INIT" == "true" ]; then
  cd /opt/omnileads/bin && ./manage.sh inicializar_entorno
fi
