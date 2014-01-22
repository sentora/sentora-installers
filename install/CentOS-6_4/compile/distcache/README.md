#Create rpm for distcache enter command

<code>wget http://www.gtlib.gatech.edu/pub/fedora.redhat/linux/releases/18/Fedora/source/SRPMS/d/distcache-1.4.5-23.src.rpm \ </code>

<code>-P $HOME/rpmbuild/SRPMS

<code>rpmbuild --rebuild $HOME/rpmbuild/SRPMS/distcache-1.4.5-23.src.rpm</code>

#Regenerate repo

<code>createrepo --update $HOME/rpmbuild/RPMS/$(uname -m)</code>

#Install

<code>sed -i 's/enabled=1/enabled=0/g' "/etc/yum.repos.d/CentOS-Media.repo"</code>

<code>yum -y update</code>

<code>sed -i 's/enabled=0/enabled=1/g' "/etc/yum.repos.d/CentOS-Media.repo"</code>

<code>yum -y update</code>

<code>yum -y install distcache-devel</code>
