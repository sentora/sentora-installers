#Create rpm for zpphp-suhosin

<code>cd $HOME/rpmbuild/SOURCES</code>

<code>git clone https://github.com/stefanesser/suhosin.git zpphp-suhosin-9.34.dev</code>

<code>tar -cvf zpphp-suhosin-9.34.dev.tar.bz2 zpphp-suhosin-9.34.dev</code>

<code>rm -rf zpphp-suhosin-9.34.dev</code>

<code>wget https://github.com/zpanel/installers/raw/master/install/CentOS-6_4/create-rpm-file/zpphp-suhosin/zpphp-suhosin.spec \ </code>

<code>-P $HOME/rpmbuild/SPECS</code>

<code>rpmbuild -ba $HOME/rpmbuild/SPECS/zpphp-suhosin.spec</code>

#Regenerate repo

<code>createrepo --update $HOME/rpmbuild/RPMS/$(uname -m)</code>

#Install

<code>sed -i 's/enabled=1/enabled=0/g' "/etc/yum.repos.d/CentOS-Media.repo"</code>

<code>yum -y update</code>

<code>sed -i 's/enabled=0/enabled=1/g' "/etc/yum.repos.d/CentOS-Media.repo"</code>

<code>yum -y update</code>

<code>yum -y install zpphp-suhosin</code>

