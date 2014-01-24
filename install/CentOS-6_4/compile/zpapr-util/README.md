Create rpm for zpapr-util (internal apr-util for zpanel)

<code>cd $HOME/rpmbuild/SOURCES</code>

<code>git clone https://github.com/apache/apr-util.git zpapr-util-1.5.3</code>

<code>cd zpapr-util-1.5.3</code>

<code>git checkout 1.5.3</code>

<code>cd ..</code>

<code>tar cvjf zpapr-util-1.5.3.tar.bz2 zpapr-util-1.5.3</code>

<code>rm -rf zpapr-util-1.5.3/</code>

<code>yum -y install expat-devel libuuid-devel postgresql-devel --downloadonly --downloaddir=$HOME/rpmbuild/RPMS/$(uname -m)</code>

<code>yum -y install expat-devel libuuid-devel postgresql-devel</code>

<code>yum -y install http://dl.fedoraproject.org/pub/epel/6/$(uname -m)/epel-release-6-8.noarch.rpm</code>

<code>yum -y update</code>

<code>yum -y install mysql-devel sqlite-devel freetds-devel --downloadonly --downloaddir=$HOME/rpmbuild/RPMS/$(uname -m)</code>

<code>yum -y install mysql-devel sqlite-devel freetds-devel</code>

<code>yum -y install openldap-devel nss-devel unixODBC-devel --downloadonly --downloaddir=$HOME/rpmbuild/RPMS/$(uname -m)</code>

<code>yum -y install openldap-devel nss-devel unixODBC-devel</code>

<code>wget https://github.com/zpanel/installers/raw/master/install/CentOS-6_4/compile/zpapr-util/zpapr-util.spec \ </code>

<code>-P $HOME/rpmbuild/SPECS</code>

<code>rpmbuild -ba $HOME/rpmbuild/SPECS/zpapr-util.spec</code> 

#Regenerate repo

<code>createrepo --update $HOME/rpmbuild/RPMS/$(uname -m)</code>

#Install

<code>sed -i 's/enabled=1/enabled=0/g' "/etc/yum.repos.d/CentOS-Media.repo"</code>

<code>yum -y update</code>

<code>sed -i 's/enabled=0/enabled=1/g' "/etc/yum.repos.d/CentOS-Media.repo"</code>

<code>yum -y update</code>

<code>yum -y install zpapr-util</code>
