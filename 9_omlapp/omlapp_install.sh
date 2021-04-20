#!/bin/bash

#######################################################################################
# Some temporal deploy ENVVARS you must SET
#######################################################################################

# TZ="America/Argentina/Cordoba"  #users Time Zone
# sca=1800 # Session cockie age
# ami_user=omnileadsami   #Asterisk AMI user
# ami_password=5_MeO_DMT  #Asterisk AMI pass
# dialer_user=demoadmin
# dialer_password=demo
# pg_database=omnileads #Postgres DB for OML
# pg_username=omnileads #Postgres username for OML
# pg_password=my_very_strong_pass #Postgres password for OML

# Cluster params
# Set this params if you want to deploy some of this components in a dedicated host

# DIALER_HOST=X.X.X.X #Wombat dialer host IPADDR
# MYSQL_HOST=X.X.X.X #Wombat dialer DB host IPADDR
# PG_HOST=X.X.X.X #Postgres host IPADDR
# PG_PORT=XXXX #Postgres tcp port
# RTPENGINE_HOST=X.X.X.X #RTPengine host IPADDR
# KAMAILIO_HOST=X.X.X.X
# ASTERISK_HOST=X.X.X.X


echo "******************** install ansible ***************************"
echo "******************** install ansible ***************************"
sleep 5
pip3 install --upgrade pip
pip3 install --user 'ansible==2.9.2'

echo "***************************** git clone omnileads repo ******************************"
echo "***************************** git clone omnileads repo ******************************"
sleep 5
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
python3 install/onpremise/deploy/ansible/edit_inventory.py --self_hosted=yes \
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

if [ $PG_HOST ]; then
  sed -i "s/#postgres_host=/postgres_host=$PG_HOST/g" ansible/deploy/inventory
fi
if [ $DIALER_HOST ]; then
  sed -i "s/#dialer_host=/dialer_host=$DIALER_HOST/g" ansible/deploy/inventory
fi
if [ $MYSQL_HOST ]; then
  sed -i "s/#mysql_host=/mysql_host=$MYSQL_HOST/g" ansible/deploy/inventory
fi
if [ $RTPENGINE_HOST ]; then
  sed -i "s/#rtpengine_host=/rtpengine_host=$RTPENGINE_HOST/g" ansible/deploy/inventory
fi
if [ $REDIS_HOST ]; then
  sed -i "s/#redis_host=/redis_host=$REDIS_HOST/g" ansible/deploy/inventory
fi
if [ $KAMAILIO_HOST ]; then
  sed -i "s/#kamailio_host=/kamailio_host=$KAMAILIO_HOST/g" ansible/deploy/inventory
fi
if [ $ASTERISK_HOST ]; then
  sed -i "s/#asterisk_host=/asterisk_host=$ASTERISK_HOST/g" ansible/deploy/inventory
fi
if [ $WEBSOCKET_HOST ]; then
  sed -i "s/websocket_host=websockets/websocket_host=$WEBSOCKET_HOST/g" ansible/deploy/inventory
fi


echo "******************************** deploy.sh execution *******************************"
echo "******************************** deploy.sh execution *******************************"
sleep 5
cd install/onpremise/deploy/ansible && ./deploy.sh -i --iface=$NIC
if [ -d /usr/local/queuemetrics/ ]; then
  systemctl stop qm-tomcat6 && systemctl disable qm-tomcat6
  systemctl stop mariadb && systemctl disable mariadb
fi
