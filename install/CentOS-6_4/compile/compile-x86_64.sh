#/bin/bash
cd /root/src/apache
yum -y install make automake autoconf gcc gcc++ wget
yum -y install rpm-build rpm-devel
mkdir -p ~/rpmbuild/{SOURCES,SPECS,BUILD,RPMS,SRPMS}
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
setenforce 0
yum -y install http://dl.fedoraproject.org/pub/epel/6/$(uname -m)/epel-release-6-8.noarch.rpm
yum -y update
yum -y install dpkg-devel
yum -y install ftp://ftp.pbone.net/mirror/ftp5.gwdg.de/pub/opensuse/repositories/home:/andnagy/RedHat_RHEL-6/$(uname -m)/checkinstall-1.6.2-20.2.$(uname -m).rpm
wget http://ftp.gnu.org/gnu/wget/wget-1.15.tar.gz
yum -y install gnutls-devel
tar -xf wget-1.15.tar.gz
cd wget-1.15
./configure --prefix=/etc/zpanel/bin/wget/ --with-ssl=gnutls
make
yum -y remove wget
make install
ln -s /etc/zpanel/bin/wget/bin/wget /usr/bin/wget
cd ..
rm -rf wget*
yum -y erase gnutls
wget http://sourceforge.net/projects/expat/files/expat/2.1.0/expat-2.1.0.tar.gz
tar -xf expat-2.1.0.tar.gz
cd expat-2.1.0
./configure --prefix=/etc/zpanel/bin/expat/
make
make install
ln -s /etc/zpanel/bin/expat/bin/xmlwf /bin/xmlwf
cd ..
rm -rf expat*
wget http://sourceforge.net/projects/libuuid/files/libuuid-1.0.2.tar.gz
tar -xf libuuid-1.0.2.tar.gz
cd libuuid-1.0.2
./configure --prefix=/etc/zpanel/bin/libuuid/
make
make install
cd ..
wget http://pkgs.fedoraproject.org/repo/pkgs/db4/db-4.8.30.tar.gz/f80022099c5742cd179343556179aa8c/db-4.8.30.tar.gz
tar -xf db-4.8.30.tar.gz
cd db-4.8.30
./configure --prefix=/etc/zpanel/bin/db/
make
make install
cd ..
wget http://ftp.postgresql.org/pub/source/v9.3.2/postgresql-9.3.2.tar.gz
tar -xf postgresql-9.3.2.tar.gz
cd postgresql
./configure --prefix=/etc/zpanel/bin/postgresql/
make
make install
cd ..
wget http://dev.mysql.com/get/Downloads/MySQL-5.6/mysql-5.6.15-linux-glibc2.5-x86_64.tar.gz
tar -xf mysql-5.6.15-linux-glibc2.5-x86_64.tar.gz


# git clone https://github.com/apache/httpd.git httpd-2.4.7
git clone http://192.168.42.1/andykimpe/httpd.git httpd-2.4.7
cd httpd-2.4.7
git checkout 2.4.7
cd ..
#git clone https://github.com/apache/apr.git httpd-2.4.7/srclib/apr
git clone http://192.168.42.1/andykimpe/apr.git httpd-2.4.7/srclib/apr
cd httpd-2.4.7/srclib/apr
git checkout 1.5.0
rm -f configure
./buildconf
mkdir include/private/
./configure --prefix=/etc/zpanel/bin/apr/
make
make install
cd ../../..
#git clone https://github.com/apache/apr-util.git httpd-2.4.7/srclib/apr-util
git clone http://192.168.42.1/andykimpe/apr-util.git httpd-2.4.7/srclib/apr-util
cd httpd-2.4.7/srclib/apr-util
git checkout 1.5.3
rm -f configure
./buildconf
./configure --prefix=/etc/zpanel/bin/apr-util/  --with-apr=/etc/zpanel/bin/apr/
make
make install
cd ../..
rm -f configure
./buildconf
#./configure --prefix=/etc/zpanel/bin/httpd --exec-prefix=/etc/zpanel/bin/httpd --enable-mods-shared="all" --enable-rewrite --enable-so --with-apr=/etc/zpanel/bin/apr/ --with-apr-util=/etc/zpanel/bin/apr-util/
./configure --prefix=/etc/zpanel/bin/httpd --exec-prefix=/etc/zpanel/bin/httpd --enable-mods-shared="all" --enable-rewrite --enable-so --with-apr=/etc/zpanel/bin/apr/ --with-apr-util=/etc/zpanel/bin/apr-util/
make
make install
sed -i 's/#LoadModule/LoadModule/g' /etc/zpanel/bin/httpd/conf/httpd.conf
sed -i 's/ServerAdmin you@example.com/ServerAdmin postmaster@localhost/g' /etc/zpanel/bin/httpd/conf/httpd.conf
sed -i 's/#ServerName www.example.com:80/ServerName localhost/g' /etc/zpanel/bin/httpd/conf/httpd.conf
rm -f /etc/init.d/httpd
wget https://github.com/zpanel/installers/raw/master/install/CentOS-6_4/compile/httpd-init -O /etc/init.d/httpd
chmod +x /etc/init.d/httpd
chkconfig --add httpd
chkconfig httpd on
service httpd start
service iptables save
service iptables stop
service sendmail stop
chkconfig sendmail off
chkconfig iptables off
cd ..
