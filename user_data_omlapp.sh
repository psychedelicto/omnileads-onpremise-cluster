#!/bin/bash

COMPONENT_REPO=https://gitlab.com/omnileads/ominicontacto.git
COMPONENT_RELEASE=master
SRC=/usr/src

CLOUD=******set your cloud environment******
#CLOUD=digitalocean
#CLOUD=onpremise
#CLOUD=linode
#CLOUD=vultr

NIC=${NIC}
TZ=${TZ}
sca=${sca}
ami_user=${ami_user}
ami_password=${ami_password}
dialer_user=${dialer_user}
dialer_password=${dialer_password}
pg_database=${pg_database}
pg_username=${pg_username}
pg_password=${pg_password}
extern_ip=none

PG_HOST=${pg_host}
PG_PORT=${pg_port}
RTPENGINE_HOST=${rtpengine_host}
REDIS_HOST=${redis_host}
DIALER_HOST=${dialer_host}
MYSQL_HOST=${mysql_host}

ENVIRONMENT_INIT=${ENV_INIT}

################## UNCOMMENT only if you work with OML-2.0 #####################
if [[ "$COMPONENT_RELEASE" == "oml-1777-epica-separacion-componentes-oml" ]]; then
  OML_2=true
  KAMAILIO_BRANCH=develop
  ASTERISK_BRANCH=develop
  RTPENGINE_BRANCH=develop
  NGINX_BRANCH=develop
  REDIS_BRANCH=develop
  POSTGRES_BRANCH=develop
  WEBSOCKET_BRANCH=develop
fi
################################################################################
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
if [[ "$OML_2" == "true" ]]; then
  PATH_DEPLOY=install/onpremise/deploy/ansible
else
  PATH_DEPLOY=ansible/deploy
fi

cd $SRC
git clone $COMPONENT_REPO
cd ominicontacto
git checkout $COMPONENT_RELEASE
git pull

if [[ "$OML_2" == "true" ]]; then
  git submodule init
  git submodule update

  cd modules/kamailio && git checkout $KAMAILIO_BRANCH
  cd ../asterisk && git checkout $ASTERISK_BRANCH
  cd ../rtpengine && git checkout $RTPENGINE_BRANCH
  cd ../nginx && git checkout $NGINX_BRANCH
  cd ../redis && git checkout $REDIS_BRANCH
  cd ../postgresql && git checkout $POSTGRES_BRANCH
  cd ../websockets && git checkout $WEBSOCKET_BRANCH
  cd ../..
fi


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

if [[ "$PG_HOST" != "NULL" ]]; then
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
if [[ "$ENVIRONMENT_INIT" != "NULL" ]]; then
  /opt/omnileads/bin/manage.sh inicializar_entorno
fi
