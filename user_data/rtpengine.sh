#!/bin/bash

NIC=$1
PRIVATE_IPV4=$(/sbin/ip -o -4 addr list $NIC | awk '{print $4}' | cut -d/ -f1)

echo "************************* yum update and install kernel-devel ***********************************"
echo "************************* yum update and install kernel-devel ***********************************"
yum update -y && yum install kernel-devel -y

echo "******************** prereq selinux and firewalld ***************************"
echo "******************** prereq selinux and firewalld ***************************"
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/sysconfig/selinux
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config
systemctl disable firewalld

echo "******************** yum install rtpengine ***************************"
echo "******************** yum install rtpwngine ***************************"
yum install epel-release -y && yum install -y curl libpcap hiredis xmlrpc-c-client json-glib libevent http://freetech.com.ar/rpms/rtpengine-5.5.3.1-1.x86_64.rpm vim

echo "************************* Discover IPs ***********************************"
echo "************************* Discover IPs ***********************************"
PUBLIC_IPV4=$(curl http://ipinfo.io/ip)
echo "public $PUBLIC_IPV4 private $PRIVATE_IPV4 are the IPs"

echo "OPTIONS="-i $PRIVATE_IPV4!$PUBLIC_IPV4  -o 60 -a 3600 -d 30 -s 120 -n $PRIVATE_IPV4:22222 -m 20000 -M 50000 -L 7 --log-facility=local1""  > /etc/rtpengine-config.conf

echo "************************* Enable and Start RTPENGINE ***********************************"
echo "************************* Enable and Start RTPENGINE ***********************************"
systemctl enable rtpengine && systemctl start rtpengine

reboot
