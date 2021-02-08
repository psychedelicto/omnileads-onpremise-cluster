#!/bin/bash

echo "******************** prereq selinux and firewalld ***************************"
echo "******************** prereq selinux and firewalld ***************************"
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/sysconfig/selinux
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config
systemctl disable firewalld

echo "******************** yum install wombat ***************************"
echo "******************** yum install wombat ***************************"
yum install wget -y
wget -P /etc/yum.repos.d http://yum.loway.ch/loway.repo
yum install wombat -y

echo "******************** postinstall configuration ***************************"
echo "******************** postinstall configuration ***************************"
cat > /usr/local/queuemetrics/tomcat/webapps/wombat/WEB-INF/tpf.properties <<EOF
#LICENZA_ARCHITETTURA=....
#START_TRANSACTION=qm_start
JDBC_DRIVER=org.mariadb.jdbc.Driver
JDBC_URL=jdbc:mariadb://${mysql_host}/${mysql_database}?user=${mysql_username}&password=${mysql_password}&autoReconnect=true
#SMTP_HOST=my.host
#SMTP_AUTH=true
#SMTP_USER=xxxx
#SMTP_PASSWORD=xxxxx
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_AUTH=yes
SMTP_USER=your-gmail-account@gmail.com
SMTP_PASSWORD=wombat
SMTP_USE_SSL=no
SMTP_FROM="WombatDialer" <your-gmail-account@gmail.com>
SMTP_DEBUG=yes

pwd.defaultLevel=1
pwd.minAllowedLevel=1
EOF

reboot
