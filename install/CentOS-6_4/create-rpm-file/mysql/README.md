dot not use

#Create rpm for mysql

<code>sudo yum -y install gperf ncurses-devel time cmake libaio-devel</code>

warning not using root user thank you

<code>cd $HOME/rpmbuild/SOURCES</code>

<code>wget http://cdn.mysql.com/Downloads/MySQL-5.6/MySQL-5.6.15-1.el6.src.rpm</code>

<code>rpm2cpio MySQL-5.6.15-1.el6.src.rpm | cpio -ivd</code>

<code>rm -f MySQL-5.6.15-1.el6.src.rpm</code>

<code>sed -i 's/--random-passwords//g' mysql.spec</code>

<code>mv mysql.spec $HOME/rpmbuild/SPECS</code>

<code>rpmbuild -ba $HOME/rpmbuild/SPECS/mysql.spec</code>

#Regenerate repo

<code>createrepo --update $HOME/rpmbuild/RPMS/$(uname -m)</code>

#Install

<code>sudo sed -i 's/enabled=1/enabled=0/g' "/etc/yum.repos.d/CentOS-Media.repo"</code>

<code>sudo yum -y update</code>

<code>sudo sed -i 's/enabled=0/enabled=1/g' "/etc/yum.repos.d/CentOS-Media.repo"</code>

<code>cd</code>

<code>sudo yum -y remove mysql mysql-libs</code>

<code>sudo yum -y update</code>

<code>sudo yum -y install MySQL-server MySQL-client</code>

<code>sudo yum -y install zpwebalizer</code>

warning pacquet removed postfix

we will create package later this program is

result mysql --version

mysql  Ver 14.14 Distrib 5.6.15, for Linux (x86_64) using  EditLine wrapper

test mysql connexion

<code>sudo service mysql start

sudo chkconfig mysql on</code>

<code>
[root@vps1 ~]# mysql -u root -phVvjKVuI


Warning: Using a password on the command line interface can be insecure.


Welcome to the MySQL monitor.  Commands end with ; or \g.


Your MySQL connection id is 5


Server version: 5.6.15

Copyright (c) 2000, 2013, Oracle and/or its affiliates. All rights reserved.


Oracle is a registered trademark of Oracle Corporation and/or its


affiliates. Other names may be trademarks of their respective owners.


Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.


mysql></code>
