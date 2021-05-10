#!/bin/bash

# Uncoment you CLOUD
#CLOUD=digitalocean
#CLOUD=onpremise
#CLOUD=linode
#CLOUD=vultr

# Set your net interfaces, you must have at least a PRIVATE_NIC
# The public interface is not mandatory, if you don't have it, you can leave it blank
PRIVATE_NIC=${NIC}
PUBLIC_NIC=

COMPONENT_REPO_URL=https://gitlab.com/omnileads/omlrtpengine.git
COMPONENT_REPO_DIR=omlrtpengine
COMPONENT_RELEASE=omlrtp-001-without-ip-discover
SRC=/usr/src

########################################## STAGE #######################################
# You must to define your scenario to deploy RTPEngine
# LAN if all agents work on LAN netwrok or VPN
# CLOUD if all agents work from the WAN
# HYBRID_1_NIC if some agents work on LAN and others from WAN and the host have ony 1 NIC
# HYBRID_1_NIC if some agents work on LAN and others from WAN and the host have 2 NICs
# (1 NIC for LAN IPADDR and 1 NIC for WAN IPADDR)
STAGE=CLOUD
##################################switch sen#########################################################

echo "******************** prereq packages ***************************"
echo "******************** prereq packages ***************************"
yum -y update
yum -y install git python3-pip python3 kernel-devel curl


echo "******************** IPV4 address config ***************************"
echo "******************** IPV4 address config ***************************"
case $CLOUD in

  digitalocean)
    echo -n "DigitalOcean"
    export PUBLIC_IPV4=$(curl -s http://169.254.169.254/metadata/v1/interfaces/public/0/ipv4/address)
    export PRIVATE_IPV4=$(curl -s http://169.254.169.254/metadata/v1/interfaces/private/0/ipv4/address)
    ;;

  linode)
    echo -n "Linode"
    export PRIVATE_IPV4=$(ip addr show $NIC |grep "inet 192.168" |awk '{print $2}' | cut -d/ -f1)
    export PUBLIC_IPV4=$(curl checkip.amazonaws.com)
    ;;

  onpremise)
    echo -n "Onpremise CentOS7 Minimal"
    export PRIVATE_IPV4=$(ip addr show $PRIVATE_NIC | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)
    if [ $PUBLIC_NIC ]; then
      export PUBLIC_IPV4=$(ip addr show $PUBLIC_NIC | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)
    else
      export PUBLIC_IPV4=$(curl ifconfig.co)
    fi
    ;;

  *)
    echo -n "you must to declare CLOUD variable"
    ;;
esac

echo "******************** prereq selinux and firewalld ***************************"
echo "******************** prereq selinux and firewalld ***************************"
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/sysconfig/selinux > /dev/null 2>&1
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config > /dev/null 2>&1
setenforce 0
systemctl disable firewalld > /dev/null 2>&1
systemctl stop firewalld > /dev/null 2>&1

echo "************************* ansible install ***********************************"
echo "************************* ansible install ***********************************"
pip3 install pip --upgrade
pip3 install 'ansible==2.9.2'
export PATH="$HOME/.local/bin/:$PATH"

echo "************************ Clone repo and run component install  *************************"
echo "************************ Clone repo and run component install  *************************"
cd $SRC
git clone $COMPONENT_REPO_URL
cd $COMPONENT_REPO_DIR
git checkout $COMPONENT_RELEASE
cd deploy

ansible-playbook rtpengine.yml -i inventory --extra-vars "rtpengine_version=$(cat ../.rtpengine_version)"

echo "******************** Overwrite rtpengine.conf ***************************"
echo "******************** Overwrite rtpengine.conf ***************************"
case $STAGE in
  CLOUD)
    echo -n "CLOUD rtpengine"
    echo "OPTIONS="-i $PUBLIC_IPV4  -o 60 -a 3600 -d 30 -s 120 -n $PRIVATE_IPV4:22222 -m 20000 -M 50000 -L 7 --log-facility=local1""  > /etc/rtpengine-config.conf
    ;;
  LAN)
    echo -n "LAN rtpengine"
    echo "OPTIONS="-i $PRIVATE_IPV4  -o 60 -a 3600 -d 30 -s 120 -n $PRIVATE_IPV4:22222 -m 20000 -M 50000 -L 7 --log-facility=local1""  > /etc/rtpengine-config.conf
    ;;
  HYBRID_1_NIC)
    echo -n "CLOUD and LAN users of rtpengine with 1 NIC"
    echo "OPTIONS="-i internal/$PRIVATE_IPV4\;external/$PUBLIC_IPV4  -o 60 -a 3600 -d 30 -s 120 -n $PRIVATE_IPV4:22222 -m 20000 -M 50000 -L 7 --log-facility=local1""  > /etc/rtpengine-config.conf
    ;;
  HYBRID_2_NIC)
    echo -n "CLOUD and LAN users of rtpengine with public and private NIC"
    echo "OPTIONS="-i $PRIVATE_IPV4  -o 60 -a 3600 -d 30 -s 120 -n $PRIVATE_IPV4:22222 -m 20000 -M 50000 -L 7 --log-facility=local1""  > /etc/rtpengine-config.conf
    ;;
  *)
    echo "ERROR you must to define the STAGE correctly"
    ;;
esac

echo "******************** Restart rtpengine ***************************"
echo "******************** Restart rtpengine ***************************"
systemctl start rtpengine

echo "************************ Remove source dirs  *************************"
echo "************************ Remove source dirs  *************************"
rm -rf $SRC/$COMPONENT_REPO_DIR
