#!/bin/bash

systemctl disable netfilter-persistent.service

apt update
apt install redis-server -y

PRIVATE_IPV4=$(curl -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/vnics/  |grep privateIp |awk '{print $3}'  |sed 's/\"//g' |sed 's/\,//g')

sed -i "s/bind 127.0.0.1/bind "$PRIVATE_IPV4"/g" /etc/redis/redis.conf

systemctl restart redis.service

reboot
