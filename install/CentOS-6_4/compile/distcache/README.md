#Create rpm for distcache enter command

<code>cd ~/rpmbuild/SRPMS</code>

<code>wget http://www.gtlib.gatech.edu/pub/fedora.redhat/linux/releases/18/Fedora/source/SRPMS/d/distcache-1.4.5-23.src.rpm</code>

<code>rpmbuild --rebuild distcache-1.4.5-23.src.rpm</code>

#Regenerate repo

<code>cd ~/rpmbuild/RPMS/$(uname -m)</code>

<code>createrepo --update ./</code>

#Install

<code>yum -y install distcache-devel</code>
