#!/bin/bash

echo "************************* yum update and install kernel-devel ***********************************"
echo "************************* yum update and install kernel-devel ***********************************"
pip3 install pip --upgrade
pip3 install 'ansible==2.9.2'

echo "******************** Install rtpengine ***************************"
echo "******************** Install rtpengine ***************************"
cd $SRC
git clone $COMPONENT_REPO
cd omlrtpengine
git checkout $COMPONENT_RELEASE
cd deploy
ansible-playbook rtpengine.yml -i inventory --extra-vars "rtpengine_version=$(cat ../.rtpengine_version)"

echo "******************** Overwrite rtpengine.conf ***************************"
echo "******************** Overwrite rtpengine.conf ***************************"

if [ "$SCENARIO" == "CLOUD" ]; then
  echo "OPTIONS="-i $PUBLIC_IPV4  -o 60 -a 3600 -d 30 -s 120 -n $PRIVATE_IPV4:22222 -m 20000 -M 50000 -L 7 --log-facility=local1""  > /etc/rtpengine-config.conf
elif [ "$SCENARIO" == "LAN" ]; then
  echo "OPTIONS="-i $PRIVATE_IPV4  -o 60 -a 3600 -d 30 -s 120 -n $PRIVATE_IPV4:22222 -m 20000 -M 50000 -L 7 --log-facility=local1""  > /etc/rtpengine-config.conf
elif [ "$SCENARIO" == "HYBRID_1_NIC" ]; then
  echo "OPTIONS="-i internal/$PRIVATE_IPV4\;external/$PUBLIC_IPV4  -o 60 -a 3600 -d 30 -s 120 -n $PRIVATE_IPV4:22222 -m 20000 -M 50000 -L 7 --log-facility=local1""  > /etc/rtpengine-config.conf
elif [ "$SCENARIO" == "HYBRID_2_NIC" ]; then
  echo "OPTIONS="-i $PRIVATE_IPV4  -o 60 -a 3600 -d 30 -s 120 -n $PRIVATE_IPV4:22222 -m 20000 -M 50000 -L 7 --log-facility=local1""  > /etc/rtpengine-config.conf
else
  echo "ERROR you must to define the SCENARIO correctly"
fi

systemctl restart rtpengine
