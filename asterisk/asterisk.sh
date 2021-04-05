#!/bin/bash

# You have to set this temporal ENVVARS before RUN this script

# RELEASE=develop
# REDIS_HOST=redis
# POSTGRESQL_HOST=postgresql
# POSTGRESQL_PORT=5432
# KAMAILIO_HOST=kamailio
# RTPENGINE_HOST=rtpengine
# POSTGRESQL_DB=omnileads
# POSTGRESQL_OMLUSER=omnileads
# POSTGRESQL_OMLPASS=my_very_strong_pass
# OMLAPP_AMI_USER=omnileadsami
# OMLAPP_AMI_PASS=5_MeO_DMT

sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/sysconfig/selinux
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config
setenforce 0

yum update -y && yum install git python3-pip python3 epel-release -y

pip3 install pip --upgrade
pip3 install 'ansible==2.9.2'

cd /usr/src
git clone https://gitlab.com/omnileads/omlacd.git
git checkout $RELEASE
cd omlacd/deploy

echo "******************************************* config and install *****************************************"
echo "******************************************* config and install *****************************************"
echo "******************************************* config and install *****************************************"
#sed -i "s/asterisk_hostname=asterisk/asterisk_hostname=$PRIVATE_IV4/g" ./inventory
#sed -i "s/kamailio_hostname=kamailio/kamailio_hostname=$KAMAILIO_HOST/g" ./inventory
#sed -i "s/redis_hostname=redis/redis_hostname=$REDIS_HOST/g" ./inventory
#sed -i "s/rtpengine_hostname=rtpengine/rtpengine_hostname=$RTPENGINE_HOST/g" ./inventory
#sed -i "s/postgres_hostname=postgres/postgres_hostname=$POSTGRESQL_HOST/g" ./inventory
sed -i "s/postgres_port=5432/postgres_port=$POSTGRESQL_PORT/g" ./inventory
sed -i "s/postgres_user=omnileads/postgres_user=$POSTGRESQL_OMLPASS/g" ./inventory
sed -i "s/postgres_password=my_very_strong_pass/postgres_password=$POSTGRESQL_OMLPASS/g" ./inventory
sed -i "s/ami_user=omnileads/ami_user=$OMLAPP_AMI_USER/g" ./inventory
sed -i "s/ami_password=C12H17N2O4P_o98o98/ami_password=$OMLAPP_AMI_PASS/g" ./inventory

ansible-playbook asterisk.yml -i inventory --extra-vars "repo_location=$(pwd)/.. asterisk_version=$(cat ../.package_version)"
