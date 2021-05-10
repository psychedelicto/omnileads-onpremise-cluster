#!/bin/bash

OML_HOST=192.168.95.201
KAM_HOST=192.168.95.201
WS_HOST=192.168.95.201

sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/sysconfig/selinux
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config
systemctl disable firewalld
systemctl stop firewalld

yum update -y && yum instal -y git python3-pip python3 epel-release
pip3 install pip --upgrade
pip3 install 'ansible==2.9.2'

git clone --branch oml-1995-dev-nginx-uwsgi-tcp-connection https://gitlab.com/omnileads/omlnginx.git
cd omlnginx/deploy

sed -i "s/omnileads_hostname=/omnileads_hostname=$OML_HOST/g" ./inventory
sed -i "s/kamailio_hostname=/kamailio_hostname=$KAM_HOST/g" ./inventory
sed -i "s/websockets_hostname=/websockets_hostname=$WS_HOST/g" ./inventory

ansible-playbook nginx.yml -i inventory --extra-vars "repo_location=$(pwd)/.. nginx_version=$(cat ../.package_version)"
