#!/bin/bash

COMPONENT_REPO=https://gitlab.com/omnileads/ominicontacto.git
COMPONENT_RELEASE=develop
SRC=/usr/src
PATH_DEPLOY=install/onpremise/deploy/ansible

# Set your Cloud Provider
CLOUD=digitalocean
#CLOUD=onpremise
#CLOUD=linode
#CLOUD=vultr

# Set the variable or user_data terraform parameter like ${TZ}
NIC=eth1
TZ=America/Argentina/Cordoba
sca=1800
ami_user=omnileadami
ami_password=5_MeO_DMT
dialer_user=demo
dialer_password=demoadmin
pg_database=omnileads
pg_username=omnileads
pg_password=098098ZZZ
extern_ip=none

PG_HOST=NULL
PG_PORT=NULL
RTPENGINE_HOST=NULL
REDIS_HOST=NULL
DIALER_HOST=NULL
MYSQL_HOST=NULL
NGINX_HOST=NULL
WEBSOCKET_HOST=NULL

ENVIRONMENT_INIT=true

KAMAILIO_BRANCH=develop
ASTERISK_BRANCH=develop
RTPENGINE_BRANCH=develop
NGINX_BRANCH=develop
REDIS_BRANCH=develop
POSTGRES_BRANCH=develop
WEBSOCKET_BRANCH=develop

echo "******************** Cloud fix /etc/hosts ***************************"
echo "******************** Cloud fix /etc/hosts ***************************"
case $CLOUD in

  digitalocean)
    echo -n "DigitalOcean"
    sed -i 's/127.0.0.1 '$(hostname)'/#127.0.0.1 '$(hostname)'/' /etc/hosts
    sed -i 's/::1 '$(hostname)'/#::1 '$(hostname)'/' /etc/hosts
    ;;
  vultr)
    echo -n "Linode"
    TEMP_HOSTNAME=$(hostname)
    sed -i 's/127.0.0.1 '$TEMP_HOSTNAME'/#127.0.0.1 '$TEMP_HOSTNAME'/' /etc/hosts
    sed -i 's/::1       '$TEMP_HOSTNAME'/#::1 '$TEMP_HOSTNAME'/' /etc/hosts
    ;;
  *)
    echo -n "you must to declare CLOUD variable"
    ;;
esac

echo "******************** SElinux and Firewalld disable ***************************"
echo "******************** SElinux and Firewalld disable ***************************"
setenforce 0
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/sysconfig/selinux
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config
systemctl disable firewalld > /dev/null 2>&1
systemctl stop firewalld > /dev/null 2>&1

echo "******************** yum update and install packages ***************************"
echo "******************** yum update and install packages ***************************"
yum -y update && yum -y install git python3 python3-pip kernel-devel

echo "******************** install ansible ***************************"
echo "******************** install ansible ***************************"
sleep 5
pip3 install --upgrade pip
pip3 install --user 'ansible==2.9.2'
export PATH="$HOME/.local/bin/:$PATH"

echo "********************************** sngrep SIP sniffer install *********************************"
echo "********************************** sngrep SIP sniffer install *********************************"
yum install ncurses-devel make libpcap-devel pcre-devel \
    openssl-devel git gcc autoconf automake -y
cd /root && git clone https://github.com/irontec/sngrep
cd sngrep && ./bootstrap.sh && ./configure && make && make install
ln -s /usr/local/bin/sngrep /usr/bin/sngrep


echo "***************************** git clone omnileads repo ******************************"
echo "***************************** git clone omnileads repo ******************************"
cd $SRC
git clone --recurse-submodules --branch $COMPONENT_RELEASE $COMPONENT_REPO
cd ominicontacto

echo "***************************** inventory setting *************************************"
echo "***************************** inventory setting *************************************"
sleep 5
python3 $PATH_DEPLOY/edit_inventory.py --self_hosted=yes \
  --ami_user=$ami_user \
  --ami_password=$ami_password \
  --dialer_user=$dialer_user \
  --dialer_password=$dialer_password \
  --ecctl=$ECCTL \
  --postgres_database=$pg_database \
  --postgres_user=$pg_username \
  --postgres_password=$pg_password \
  --sca=$SCA \
  --schedule=$schedule \
  --extern_ip=$extern_ip \
  --TZ=$TZ

if [[ "$PG_HOST"  != "NULL" ]]; then
  sed -i "s/#postgres_host=/postgres_host=$PG_HOST/g" $PATH_DEPLOY/inventory
fi
if [[ "$DIALER_HOST" != "NULL" ]]; then
  sed -i "s/#dialer_host=/dialer_host=$DIALER_HOST/g" $PATH_DEPLOY/inventory
fi
if [[ "$MYSQL_HOST" != "NULL" ]]; then
  sed -i "s/#mysql_host=/mysql_host=$MYSQL_HOST/g" $PATH_DEPLOY/inventory
fi
if [[ "$RTPENGINE_HOST" != "NULL" ]]; then
  sed -i "s/#rtpengine_host=/rtpengine_host=$RTPENGINE_HOST/g" $PATH_DEPLOY/inventory
fi
if [[ "$REDIS_HOST" != "NULL" ]]; then
  sed -i "s/#redis_host=/redis_host=$REDIS_HOST/g" $PATH_DEPLOY/inventory
fi
if [[ "$NGINX_HOST" != "NULL" ]]; then
  sed -i "s/#nginx_host=/nginx_host=$NGINX_HOST/g" $PATH_DEPLOY/inventory
fi
if [[ "$WEBSOCKET_HOST" != "NULL" ]]; then
  sed -i "s/#websocket_host=/websocket_host=$WEBSOCKET_HOST/g" $PATH_DEPLOY/inventory
fi

echo "******************************** deploy.sh execution *******************************"
echo "******************************** deploy.sh execution *******************************"
sleep 5

cd $PATH_DEPLOY
./deploy.sh -i --iface=$NIC

if [ -d /usr/local/queuemetrics/ ]; then
  systemctl stop qm-tomcat6 && systemctl disable qm-tomcat6
  systemctl stop mariadb && systemctl disable mariadb
fi

echo "********************************** setting demo environment *********************************"
echo "********************************** setting demo environment *********************************"
if [[ "$ENVIRONMENT_INIT" == "true" ]]; then
  /opt/omnileads/bin/manage.sh inicializar_entorno
fi
