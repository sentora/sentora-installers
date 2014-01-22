#Create rpm for apr-util

<code>cd ~/rpmbuild/SOURCES</code>

<code>wget http://www.gtlib.gatech.edu/pub/apache/apr/apr-util-1.5.3.tar.bz2</code>

<code>yum -y install expat-devel libuuid-devel postgresql-devel mysql-devel sqlite-devel --downloadonly --downloaddir=~/rpmbuild/RPMS/$(uname -m)</code>

<code>yum -y install expat-devel libuuid-devel postgresql-devel mysql-devel sqlite-devel</code>

<code>wget http://www.gtlib.gatech.edu/pub/apache/apr/apr-util-1.5.3.tar.bz2</code>

<code>rpmbuild -tb apr-util-1.5.3.tar.bz2</code>

#Regenerate repo

<code>cd ~/rpmbuild/RPMS/$(uname -m)</code>

<code>createrepo --update ./</code>

#Install

<code>yum -y install apr-devel</code>
