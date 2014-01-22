#Create rpm for git enter command

<code>yum -y update</code>

<code>yum -y install wget openssl-devel zlib-devel perl-devel</code>

<code>yum -y groupinstall "Development Tools"</code>

<code>mkdir -p ~/rpmbuild/{SOURCES,SPECS,BUILD,RPMS,SRPMS}</code>

<code>wget https://github.com/git/git/archive/v1.9-rc0.tar.gz -O ~/rpmbuild/SOURCES/zpgit-1.9-rc0.tar.gz</code>

<code>cd ~/rpmbuild/SPECS/</code> 

<code>wget https://github.com/zpanel/installers/raw/master/install/CentOS-6_4/compile/zpgit/zpgit.spec</code>

<code>rpmbuild -ba ~/rpmbuild/SPECS/zpgit.spec</code>

# install

<code>yum -y remove git</code>

<code>yum -y localinstall ~/rpmbuild/RPMS/$(uname -m)/git-1.9.rc0-1.$(uname -m).rpm \ </code>

<code>/root/rpmbuild/RPMS/$(uname -m)/git-debuginfo-1.9.rc0-1.$(uname -m).rpm</code>

#Result

[root@vps1 ~]# git --version

git version 1.9-rc0

[root@vps1 ~]#


