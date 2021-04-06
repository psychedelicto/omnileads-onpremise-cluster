#!/bin/bash

PRIVATE_IPV4=$(ip addr show eth1 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)
PUBLIC_IPV4=$(ip addr show eth0 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)

REPO_URL=https://github.com/psychedelicto/omnileads-onpremise-cluster.git
REPO_RELEASE=develop

############### VULTR and OMniLeads env settings ###############################
TEMP_HOSTNAME=$(hostname)
sed -i 's/127.0.0.1 '$TEMP_HOSTNAME'/#127.0.0.1 '$TEMP_HOSTNAME'/' /etc/hosts
sed -i 's/::1       '$TEMP_HOSTNAME'/#::1 '$TEMP_HOSTNAME'/' /etc/hosts

systemctl stop firewalld
systemctl disable firewalld
################################################################################

export NIC=eth1
export RELEASE=release-1.14.0

export TZ="America/Argentina/Cordoba"
export sca=1800
export ami_user=omnileadsami
export ami_password=5_MeO_DMT
export dialer_user=demoadmin
export dialer_password=demo
export pg_database=omnileads
export pg_username=omnileads
export pg_password=my_very_strong_pass
export extern_ip=$PUBLIC_IPV4

#export PG_HOST=
#export PG_PORT=
#export KAMAILIO_HOST=
#export RTPENGINE_HOST=
#export ASTERISK_HOST=
#export REDIS_HOST=
#export DIALER_HOST=
#export MYSQL_HOST=

chmod +x omlapp_install.sh
./omlapp_install.sh

reboot
