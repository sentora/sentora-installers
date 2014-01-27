#Create rpm for firebird

<code>sudo yum -y install bzip2-devel gmp-devel  libedit-devel libtool-ltdl-devel libevent-devel libc-client-devel \ </code>

<code>net-snmp-devel libxslt-devel libXpm-devel libjpeg-devel libpng-devel freetype-devel libtidy-devel aspell-devel \ </code>

<code>recode-devel libicu-devel enchant-devel</code>

<code>wget http://dl.fedoraproject.org/pub/epel/6/SRPMS/firebird-2.5.2.26539.0-3.el6.src.rpm -P $HOME/rpmbuild/SRPMS</code>

<code>rpmbuild --rebuild $HOME/rpmbuild/SRPMS/firebird-2.5.2.26539.0-3.el6.src.rpm</code>

#Regenerate repo

<code>createrepo --update $HOME/rpmbuild/RPMS/$(uname -m)</code>

#Install

<code>sudo sed -i 's/enabled=1/enabled=0/g' "/etc/yum.repos.d/CentOS-Media.repo"</code>

<code>sudo yum -y update</code>

<code>sudo sed -i 's/enabled=0/enabled=1/g' "/etc/yum.repos.d/CentOS-Media.repo"</code>

<code>sudo yum -y update</code>

<code>sudo yum -y install firebird-devel</code>
