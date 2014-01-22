#Create rpm for apr

<code>wget http://www.gtlib.gatech.edu/pub/apache/apr/apr-1.5.0.tar.bz2 \ </code>

<code>-P $HOME/rpmbuild/SOURCES</code>

<code>rpmbuild -tb $HOME/rpmbuild/SOURCES/apr-1.5.0.tar.bz2</code>

#Regenerate repo

<code>createrepo --update $HOME/rpmbuild/RPMS/$(uname -m)</code>

#Install

<code>sed -i 's/enabled=1/enabled=0/g' "/etc/yum.repos.d/CentOS-Media.repo"</code>

<code>yum -y update</code>

<code>sed -i 's/enabled=0/enabled=1/g' "/etc/yum.repos.d/CentOS-Media.repo"</code>

<code>yum -y update</code>

<code>yum -y install apr-devel</code>
