#!/bin/bash

apt-get update

apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
apt-key fingerprint 0EBFCD88

add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

apt-get update
apt-get -y install docker-ce docker-ce-cli containerd.io

systemctl enable docker.service
systemctl enable containerd.service
systemctl start docker.service
systemctl start containerd.service

curl -L "https://github.com/docker/compose/releases/download/1.28.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

cat > docker-compose.yml <<EOF
version: '3.7'
services:
  pbx-emulator:
    container_name: pbx-emulator
    hostname: pbx-emulator
    dns: 8.8.8.8
    environment:
      - PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
    image: freetechsolutions/pbx-emulator:0.2
    networks:
      - dev_net
    ports:
      - 5060:5060/udp
      - 10000-10020:10000-10020/udp
    privileged: true
    restart: on-failure
    stdin_open: true
    stop_grace_period: 1m30s
    tty: true

networks:
  dev_net:
    ipam:
      driver: default
      config:
        - subnet: "172.20.0.0/24"
EOF

/usr/local/bin/docker-compose up -d

reboot
