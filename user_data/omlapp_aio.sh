#!/bin/bash

NIC=$1 #NET Interface to attach services

SRCPATH=/usr/src # Dir to download oml repo and extras
omnileads_release="release-1.14.0"  #OMniLeads release to deploy
TZ="America/Argentina/Cordoba"  #users Time Zone
sca=1800 # Session cockie age
ami_user=omnileadsami   #Asterisk AMI user
ami_password=5_MeO_DMT  #Asterisk AMI pass
dialer_user=demoadmin
dialer_password=demo
pg_database=omnileads #Postgres DB for OML
pg_username=omnileads #Postgres username for OML
pg_password=my_very_strong_pass #Postgres password for OML

#######################################################################################
# Cluster params
# Set this params if you want to deploy some of this components in a dedicated host
#######################################################################################
#dialer_host=localhost #Wombat dialer host IPADDR
#dialer_mysql_host=localhost #Wombat dialer DB host IPADDR
#pg_host=localhost #Postgres host IPADDR
#pg_port=5432 #Postgres tcp port
#rtpengine_host=localhost #RTPengine host IPADDR
#######################################################################################

echo "******************** fix hostname and localhost issue on some cloud instances ***************************"
echo "******************** fix hostname and localhost issue on some cloud instances ***************************"
TEMP_HOSTNAME=$(hostname)
sed -i 's/127.0.0.1 '${TEMP_HOSTNAME}'/#127.0.0.1 '${TEMP_HOSTNAME}'/' /etc/hosts
sed -i 's/::1 '${TEMP_HOSTNAME}'/#::1 '${TEMP_HOSTNAME}'/' /etc/hosts

echo "******************** SElinux disable ***************************"
echo "******************** SElinux disable ***************************"
setenforce 0
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/sysconfig/selinux
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config

echo "******************** yum update and install packages ***************************"
echo "******************** yum update and install packages ***************************"
yum -y update && yum -y install git python3-pip kernel-devel

echo "******************** install ansible ***************************"
echo "******************** install ansible ***************************"
pip3 install --upgrade pip
pip3 install --user 'ansible==2.9.2'

echo "***************************** git clone omnileads repo ******************************"
echo "***************************** git clone omnileads repo ******************************"
sleep 5
cd $SRCPATH
git clone https://gitlab.com/omnileads/ominicontacto.git
cd ominicontacto && git checkout $omnileads_release

echo "***************************** inventory setting *************************************"
echo "***************************** inventory setting *************************************"
sleep 5
python3 ansible/deploy/edit_inventory.py --self_hosted=yes \
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
  --extern_ip=none
  --TZ=$TZ
  #######################################################################################
  # Cluster params
  # Set this params if you want to deploy some of this components in a dedicated host
  #######################################################################################
  # \ --postgres_host=$pg_host \
  #--postgres_port=$pg_port \
  #--dialer_host=$dialer_host \
  #--rtpengine_host=$rtpengine_host \
  #--mysql_host=$dialer_mysql_host
  #######################################################################################

echo "******************************** deploy.sh execution *******************************"
echo "******************************** deploy.sh execution *******************************"
sleep 5
cd ansible/deploy && ./deploy.sh -i --iface=$NIC
if [ -d /usr/local/queuemetrics/ ]; then
  systemctl stop qm-tomcat6 && systemctl disable qm-tomcat6
  systemctl stop mariadb && systemctl disable mariadb
fi

echo "********************************** sngrep SIP sniffer install *********************************"
echo "********************************** sngrep SIP sniffer install *********************************"
yum install ncurses-devel make libpcap-devel pcre-devel \
    openssl-devel git gcc autoconf automake -y
cd /root && git clone https://github.com/irontec/sngrep
cd sngrep && ./bootstrap.sh && ./configure && make && make install
ln -s /usr/local/bin/sngrep /usr/bin/sngrep

echo "********************************** setting demo environment *********************************"
echo "********************************** setting demo environment *********************************"
cd /opt/omnileads/bin && ./manage.sh inicializar_entorno

reboot
