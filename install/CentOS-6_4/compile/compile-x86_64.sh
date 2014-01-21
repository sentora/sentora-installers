#/bin/bash
mkdir ~/src/
cd ~/src/
mkdir ~/rpm
mkdir ~/deb
yum install -y yum-plugin-downloadonly
yum -y install make automake autoconf gcc gcc++ gcc-c++ --downloadonly --downloaddir=~/rpm
yum -y install make automake autoconf gcc gcc++ gcc-c++ wget
yum -y install rpm-build rpm-devel python-devel libjpeg-devel libtiff-devel bzip2-devel libXpm-devel gpm-devel --downloadonly --downloaddir=~/rpm
yum -y install rpm-build rpm-devel python-devel libjpeg-devel libtiff-devel bzip2-devel libXpm-devel gpm-devel
mkdir -p ~/rpmbuild/{SOURCES,SPECS,BUILD,RPMS,SRPMS}
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
setenforce 0
yum -y install http://dl.fedoraproject.org/pub/epel/6/$(uname -m)/epel-release-6-8.noarch.rpm
yum -y update --downloadonly --downloaddir=~/rpm
yum -y update
yum -y install dpkg-devel --downloadonly --downloaddir=~/rpm
yum -y install dpkg-devel
yum -y install gnutls-devel perl-devel asciidoc xmlto curl-devel --downloadonly --downloaddir=~/rpm
yum -y install gnutls-devel perl-devel asciidoc xmlto curl-devel
yum -y install zlib-devel perl-ExtUtils-MakeMaker openssl-devel expat-devel --downloadonly --downloaddir=~/rpm
yum -y install zlib-devel perl-ExtUtils-MakeMaker openssl-devel expat-devel
yum groupinstall "Development Tools" -y --downloadonly --downloaddir=~/rpm
yum groupinstall "Development Tools" -y
yum -y install expat-devel libuuid-devel db4-devel postgresql-devel mysql-devel freetds-devel unixODBC-devel openldap-devel nss-devel sqlite-devel --downloadonly --downloaddir=~/rpm
yum -y install expat-devel libuuid-devel db4-devel postgresql-devel mysql-devel freetds-devel unixODBC-devel openldap-devel nss-devel sqlite-devel
yum -y install pcre-devel lua-devel libxml2-devel --downloadonly --downloaddir=~/rpm
yum -y install pcre-devel lua-devel libxml2-devel
rm -f ~/rpm/git*
rm -f ~/rpm/perl-Git*
rm -f ~/rpm/apr*


wget https://github.com/git/git/archive/v1.9-rc0.tar.gz -O git-1.9-rc0.tar.gz
tar -xf git-1.9-rc0.tar.gz
cd git-1.9-rc0
make configure
./configure --prefix=/opt/git
make
make install
cd ..
rm -rf git-1.9-rc0
mkdir git-1.9-rc0
cd git-1.9-rc0
cp -R /opt/git/* ./
rm -rf /opt/git/
wget https://github.com/zpanel/installers/raw/master/install/CentOS-6_4/compile/git/Makefile
make install
git clone http://checkinstall.izto.org/checkinstall.git
cd checkinstall
git checkout -b 1.6.3
make
make install PREFIX=/opt/checkinstall-old/
cd ..
rm -rf checkinstall
mkdir checkinstall
cd checkinstall
cp -R /opt/checkinstall-old/* ./
wget https://github.com/zpanel/installers/raw/master/install/CentOS-6_4/compile/checkinstall/Makefile
/opt/checkinstall-old/sbin/checkinstall --pkgname=checkinstall --pkgversion=1.6.3 --maintainer=andykimpe@gmail.com --requires=gettext-devel --install=yes -y -R make install
rm -rf /opt/checkinstall-old/
cd ..
rm -rf checkinstall
make uninstall
checkinstall --pkgname=git --pkgversion=1.9.rc0 --maintainer=andykimpe@gmail.com --requires=zlib-devel,subversion --install=yes -y -R make install
cd ..
rm -rf *
wget http://ftp.gnu.org/gnu/wget/wget-1.15.tar.gz
tar -xf wget-1.15.tar.gz
cd wget-1.15
./configure --prefix=/usr --with-ssl=openssl
make
yum -y remove wget
checkinstall --pkgname=wget --pkgversion=1.15 --maintainer=andykimpe@gmail.com --requires=openssl-devel --install=yes -y -R make install
cd ..
rm -rf wget*
cd ~/rpmbuild/SOURCES
wget http://www.gtlib.gatech.edu/pub/apache/apr/apr-1.5.0.tar.bz2
wget http://www.gtlib.gatech.edu/pub/apache/apr/apr-util-1.5.3.tar.bz2
rpmbuild -tb apr-1.5.0.tar.bz2
yum -y install ~/rpmbuild/RPMS/$(uname -m)/apr-1.5.0-1.$(uname -m).rpm ~/rpmbuild/RPMS/$(uname -m)/apr-devel-1.5.0-1.x86_64.rpm ~/rpmbuild/RPMS/$(uname -m)/apr-debuginfo-1.5.0-1.$(uname -m).rpm
rpmbuild -tb apr-util-1.5.3.tar.bz2
rm -f ~/rpmbuild/RPMS/$(uname -m)/apr-util-dbm-1.5.3-1.$(uname -m).rpm ~/rpmbuild/RPMS/$(uname -m)/apr-util-pgsql-1.5.3-1.$(uname -m).rpm ~/rpmbuild/RPMS/$(uname -m)/apr-util-mysql-1.5.3-1.$(uname -m).rpm ~/rpmbuild/RPMS/$(uname -m)/apr-util-sqlite-1.5.3-1.$(uname -m).rpm ~/rpmbuild/RPMS/$(uname -m)/apr-util-freetds-1.5.3-1.$(uname -m).rpm ~/rpmbuild/RPMS/$(uname -m)/apr-util-odbc-1.5.3-1.$(uname -m).rpm ~/rpmbuild/RPMS/$(uname -m)/apr-util-ldap-1.5.3-1.$(uname -m).rpm ~/rpmbuild/RPMS/$(uname -m)/apr-util-openssl-1.5.3-1.$(uname -m).rpm ~/rpmbuild/RPMS/$(uname -m)/apr-util-nss-1.5.3-1.$(uname -m).rpm ~/rpmbuild/RPMS/$(uname -m)/apr-util-debuginfo-1.5.3-1.$(uname -m).rpm
yum -y install ~/rpmbuild/RPMS/$(uname -m)/apr-util-1.5.3-1.$(uname -m).rpm ~/rpmbuild/RPMS/$(uname -m)/apr-util-devel-1.5.3-1.$(uname -m).rpm
cd ~/rpmbuild/SRPMS
wget http://www.gtlib.gatech.edu/pub/fedora.redhat/linux/releases/18/Fedora/source/SRPMS/d/distcache-1.4.5-23.src.rpm
rpmbuild --rebuild distcache-1.4.5-23.src.rpm
yum -y install ~/rpmbuild/RPMS/$(uname -m)/distcache-1.4.5-23.$(uname -m).rpm ~/rpmbuild/RPMS/$(uname -m)/distcache-devel-1.4.5-23.$(uname -m).rpm

cd ~/src/
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
./configure --prefix=/etc/zpanel/bin/apr
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
./configure --prefix=/etc/zpanel/bin/httpd --exec-prefix=/etc/zpanel/bin/httpd --enable-mods-shared="all" --enable-rewrite --enable-so --with-apr=/etc/zpanel/bin/apr/ --with-apr-util=/etc/zpanel/bin/apr-util/
make
make install
cd ..
rm -rf httpd-2.4.7
mkdir zphttpd-2.4.7
cd zphttpd-2.4.7
mkdir apr
mkdir apr-util
mkdir httpd
cp -R /etc/zpanel/bin/apr/* apr
cp -R /etc/zpanel/bin/apr-util/* apr-util
cp -R /etc/zpanel/bin/httpd/* httpd
rm -rf /etc/zpanel/bin/apr/
rm -rf /etc/zpanel/bin/apr-util/
rm -rf /etc/zpanel/bin/httpd/
wget https://github.com/zpanel/installers/raw/master/install/CentOS-6_4/compile/httpd/httpd-init -P httpd
wget https://github.com/zpanel/installers/raw/master/install/CentOS-6_4/compile/httpd/Makefile
checkinstall --pkgname=zphttpd --pkgversion=2.4.7 --maintainer=andykimpe@gmail.com --requires=apr-devel,apr-util-devel,distcache,pkgconfig,libtool --conflicts=httpd,httpd-suexec,webserver,httpd-mmn,mod_dav,secureweb-manual,apache-manual,apache,apache2,nginx --install=yes -y -R make install
