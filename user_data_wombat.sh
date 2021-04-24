#!/bin/bash

MYSQL_HOST=${mysql_host}
MYSQL_DB=${mysql_database}
MYSQL_USER=${mysql_username}
MYSQL_PASS=${mysql_password}

echo "******************** prereq selinux and firewalld ***************************"
echo "******************** prereq selinux and firewalld ***************************"
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/sysconfig/selinux
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config
setenforce 0
systemctl disable firewalld > /dev/null 2>&1
systemctl stop firewalld > /dev/null 2>&1

echo "******************** yum install wombat ***************************"
echo "******************** yum install wombat ***************************"
yum -y install git wget
wget -P /etc/yum.repos.d http://yum.loway.ch/loway.repo
yum -y install wombat

echo "******************** postinstall configuration ***************************"
echo "******************** postinstall configuration ***************************"
cat > /usr/local/queuemetrics/tomcat/webapps/wombat/WEB-INF/tpf.properties <<EOF
#LICENZA_ARCHITETTURA=....
#START_TRANSACTION=qm_start
JDBC_DRIVER=org.mariadb.jdbc.Driver
JDBC_URL=jdbc:mariadb://$MYSQL_HOST/$MYSQL_DB?user=$MYSQL_USER&password=$MYSQL_PASS&autoReconnect=true
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
