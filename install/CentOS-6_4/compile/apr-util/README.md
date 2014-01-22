#Create rpm for apr-util

<code>cd ~/rpmbuild/SOURCES</code>

<code>wget http://www.gtlib.gatech.edu/pub/apache/apr/apr-util-1.5.3.tar.bz2</code>

<code>yum -y install expat-devel libuuid-devel postgresql-devel --downloadonly --downloaddir=~/rpmbuild/RPMS/$(uname -m)</code>

<code>yum -y install expat-devel libuuid-devel postgresql-devel</code>

<code>yum -y install mysql-devel sqlite-devel freetds-devel unixODBC-devel --downloadonly --downloaddir=~/rpmbuild/RPMS/$(uname -m)</code>

<code>yum -y install http://dl.fedoraproject.org/pub/epel/6/$(uname -m)/epel-release-6-8.noarch.rpm</code>

<code>yum -y update</code>

<code>yum -y install mysql-devel sqlite-devel freetds-devel unixODBC-devel</code>

<code>yum -y install openldap-devel nss-devel freetds-devel --downloadonly --downloaddir=~/rpmbuild/RPMS/$(uname -m)</code>

<code>yum -y install openldap-devel nss-devel</code>

<code>rpmbuild -tb apr-util-1.5.3.tar.bz2</code>

#Regenerate repo

<code>cd ~/rpmbuild/RPMS/$(uname -m)</code>

<code>createrepo --update ./</code>

#Install

<code>yum -y install apr-util-devel</code>
