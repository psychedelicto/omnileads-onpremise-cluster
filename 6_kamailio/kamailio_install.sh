#!/bin/bash

echo "************************ install ansible *************************"
echo "************************ install ansible *************************"
echo "************************ install ansible *************************"
pip3 install pip --upgrade
pip3 install 'ansible==2.9.2'
export PATH="$HOME/.local/bin/:$PATH"


echo "************************ clone REPO *************************"
echo "************************ clone REPO *************************"
echo "************************ clone REPO *************************"
cd $SRC
git clone $COMPONENT_REPO
cd omlkamailio
git checkout $COMPONENT_RELEASE
cd deploy

echo "************************ config and install *************************"
echo "************************ config and install *************************"
echo "************************ config and install *************************"
sed -i "s/asterisk_hostname=/asterisk_hostname=$ASTERISK_HOST/g" ./inventory
sed -i "s/kamailio_hostname=/kamailio_hostname=$PRIVATE_IPV4/g" ./inventory
sed -i "s/redis_hostname=/redis_hostname=$REDIS_HOST/g" ./inventory
sed -i "s/rtpengine_hostname=/rtpengine_hostname=$RTPENGINE_HOST/g" ./inventory
sed -i "s/shm_size=/shm_size=$KAMAILIO_SHM_SIZE/g" ./inventory
sed -i "s/pkg_size=/pkg_size=$KAMAILIO_PKG_SIZE/g" ./inventory

ansible-playbook kamailio.yml -i inventory --extra-vars "repo_location=$(pwd)/.. kamailio_version=$(cat ../.package_version)"
