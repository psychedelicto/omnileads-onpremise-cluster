#!/bin/bash

OMLNFSASTHOST=192.168.95.201
PRIVATE_IPV4=192.16.95.205
HOST_DIR=/opt/omnileads/asterisk/var/spool/asterisk/monitor
DEVICE=/dev/sda1 #/dev/disk/by-id/scsi-0DO_Volume_"${dev_name}"

apt update
apt install nfs-kernel-server -y

echo "$DEVICE" /opt ext4 defaults,nofail,discard,noatime 0 2" >> /etc/fstab

mount $DEVICE /opt

mkdir -p $HOST_DIR
chown nobody:nogroup $HOST_DIR

echo "$HOST_DIR $OMLNFSASTHOST(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports

systemctl restart nfs-kernel-server

reboot
