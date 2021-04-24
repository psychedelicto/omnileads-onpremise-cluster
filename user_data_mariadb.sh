#!/bin/bash

CLOUD=******set your cloud environment******
#CLOUD=digitalocean
#CLOUD=onpremise
#CLOUD=linode
#CLOUD=vultr

NIC=${NIC}

# Dialer User and Pass credentials
DIALER_USER=${dialer_username}
DIALER_PASS=${dialer_password}

echo "******************** yum install packages ***************************"
echo "******************** yum install packages ***************************"
yum install -y epel-release git ipcalc

echo "******************** IPV4 address config ***************************"
echo "******************** IPV4 address config ***************************"
case $CLOUD in
  digitalocean)
    echo -n "DigitalOcean\n"
     PRIVATE_IPV4=$(curl -s http://169.254.169.254/metadata/v1/interfaces/private/0/ipv4/address)
     NETMASK=$(curl -s http://169.254.169.254/metadata/v1/interfaces/private/0/ipv4/netmask)
     NETADDR_IPV4=$(ipcalc -n $PRIVATE_IPV4 $PRIVATE_NETMASK |cut -d = -f 2)
    ;;
  linode)
    echo -n "Linode"
     IPADDR_MASK=$(ip addr show $NIC | grep "192.168" | awk '{print $2}')
     NETADDR_IPV4=$(ipcalc -n $IPADDR_MASK |cut -d = -f 2)
     NETMASK=$(ip addr show $NIC | grep "192.168" | awk '{print $2}' | cut -d/ -f2)
    ;;
  onpremise)
    echo -n "Onpremise CentOS7 Minimal"
     IPADDR_MASK=$(ip addr show $NIC | grep "inet\b" | awk '{print $2}')
     NETADDR_IPV4=$(ipcalc -n $IPADDR_MASK |cut -d = -f 2)
     NETMASK=$(ip addr show $NIC | grep "inet\b" | awk '{print $2}' | cut -d/ -f2)
    ;;
  *)
    echo -n "you must to declare CLOUD variable"
    ;;
esac

LAN_ADDRESS="$NETADDR_IPV4/$NETMASK"
echo "******* $LAN_ADDRESS\n"
sleep 2

echo "******************** prereq selinux and firewalld ***************************"
echo "******************** prereq selinux and firewalld ***************************"
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/sysconfig/selinux
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config
setenforce 0
systemctl disable firewalld > /dev/null 2>&1
systemctl stop firewalld > /dev/null 2>&1

echo "******************** yum install mariaDB ***************************"
echo "******************** yum install mariaDB ***************************"
yum install mariadb-server -y
systemctl start mariadb
systemctl enable mariadb

echo "******************** postinstall configuration ***************************"
echo "******************** postinstall configuration ***************************"
mysql -e "GRANT ALL ON *.* to '$DIALER_USER'@'$LAN_ADDRESS' IDENTIFIED BY '$DIALER_PASS' WITH GRANT OPTION;"
