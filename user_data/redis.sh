#!/bin/bash

PRIVATE_IPV4=192.168.95.205

systemctl disable netfilter-persistent.service

apt update
apt install redis-server -y

sed -i "s/bind 127.0.0.1/bind "$PRIVATE_IPV4"/g" /etc/redis/redis.conf

systemctl restart redis.service

reboot
