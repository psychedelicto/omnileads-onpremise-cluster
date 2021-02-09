#!/bin/bash

OMLASTPGSQLHOST=pgsql
OMLASTPGSQLPORT=5432
OMLASTPGSQLPASS=admin123

setenforce 0
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/sysconfig/selinux
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config

systemctl disable firewalld

useradd omnileads -s /bin/bash -u 1001 -g 1001
rpm -Uvh https://yum.postgresql.org/11/redhat/rhel-7-x86_64/pgdg-redhat-repo-latest.noarch.rp

yum install -y https://fts-public-packages.s3-sa-east-1.amazonaws.com/asterisk-16.16.0.x86_64.rpm python3 uriparser postgresql11-odbc postgresql11 git python3-psycopg2 gsm vim libxslt

#vim /etc/profile.d/omnileads_envars.sh

cat > /etc/profile.d/omnileads_envars.sh <<EOF
# ------------------------------------
# #Aqui va IP/hostname del server con postgresql
PGHOST=$OMLASTPGSQLHOST
# #Aqui va el nombre de la database con postgresql
PGDATABASE=omnileads
# #Aqui va el usuario de la database
PGUSER=omnileads
# #Su contraseña
PGPASSWORD=$OMLASTPGSQLPASS
# #Dejar esta variable asi
ASTERISK_LOCATION=/opt/omnileads/asterisk
#
export PGHOST PGDATABASE PGUSER PGPASSWORD ASTERISK_LOCATION REDIS_HOSTNAME
# ------------------------------------------------------------------------------
EOF

su omnileads
cd /opt/omnileads/asterisk/var/lib/asterisk/agi-bin/
pip3 install -e git+https://github.com/SrMoreno/pyst2@master#egg=pyst2 --user
pip3 install 'redis==3.5.3' --user

ln -s /opt/omnileads/asterisk/sbin/asterisk /usr/sbin/asterisk


cat > /etc/odbc.ini <<EOF
#
[asteriskara]
# Description = PostgreSQL connection to 'asterisk' database
Driver = PostgreSQL
# #database
Database = omnileads
# #database IP
Servername = $OMLASTPGSQLHOST
# #database user
UserName = omnileads
# #database pass
Password = $OMLASTPGSQLPASS
Port = $OMLASTPGSQLPORT
Protocol = 8.1
ReadOnly = No
RowVersioning = No
ShowSystemTables = No
ShowOidColumn = No
FakeOidIndex = No
#ConnSettings =

EOF


cat > /etc/odbcinst.ini <<EOF
#
# # Example driver definitions
#
# # Driver from the postgresql-odbc package
# # Setup from the unixODBC package
[PostgreSQL]
# Description = ODBC for PostgreSQL
Driver = /usr/pgsql-11/lib/psqlodbcw.so
Setup = /usr/lib/libodbcpsqlS.so
Driver64 =/usr/pgsql-11/lib/psqlodbcw.so
Setup64 = /usr/lib64/libodbcpsqlS.so
FileUsage = 1
EOF

systemctl enable asterisk && systemctl start asterisk
