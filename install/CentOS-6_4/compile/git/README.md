#Create rpm for git enter command

<code>mkdir -p ~/rpmbuild/{SOURCES,SPECS,BUILD,RPMS,SRPMS}</code>

<code>yum install -y yum-plugin-downloadonly</code>

<code>yum -y update --downloadonly --downloaddir=~/rpmbuild/RPMS/$(uname -m)</code>

<code>yum -y update</code>

<code>yum -y install openssl-devel zlib-devel perl-devel --downloadonly --downloaddir=~/rpmbuild/RPMS/$(uname -m)</code>

<code>yum -y install wget openssl-devel zlib-devel perl-devel</code>

<code>yum -y groupinstall "Development Tools" --downloadonly --downloaddir=~/rpmbuild/RPMS/$(uname -m)</code>

<code>rm -f ~/rpmbuild/RPMS/$(uname -m)/apr*</code>

<code>rm -f ~/rpmbuild/RPMS/$(uname -m)/git*</code>

<code>rm -f ~/rpmbuild/RPMS/$(uname -m)/perl-Git*</code>

<code>yum -y groupinstall "Development Tools"</code>

<code>yum -y install curl-devel expat-devel xmlto asciidoc --downloadonly --downloaddir=~/rpmbuild/RPMS/$(uname -m)</code>

<code>yum -y install curl-devel expat-devel xmlto asciidoc</code>

<code>wget https://github.com/git/git/archive/v1.9-rc0.tar.gz -O ~/rpmbuild/SOURCES/git-1.9-rc0.tar.gz</code>

<code>cd ~/rpmbuild/SPECS/</code> 

<code>wget https://github.com/zpanel/installers/raw/master/install/CentOS-6_4/compile/git/git.spec</code>

<code>rpmbuild -ba ~/rpmbuild/SPECS/git.spec</code>

#Create repo

<code>yum -y install createrepo --downloadonly --downloaddir=~/rpmbuild/RPMS/$(uname -m)</code>

<code>yum -y install createrepo</code>

<code>createrepo ~/rpmbuild/RPMS/$(uname -m)</code>

change CentOS-Media.repo

<code>vi /etc/yum.repos.d/CentOS-Media.repo</code>

replace

baseurl=file:///media/CentOS/

        file:///media/cdrom/

        file:///media/cdrecorder/
        
by

baseurl=file:///root/rpmbuild/RPMS/$basearch

or no root

baseurl=file:///home/yourname/rpmbuild/RPMS/$basearch

replace

gpgcheck=1

by

gpgcheck=0

replace

enabled=0

by

enabled=1

add

priority=1

protect=1

esc

:wq

<code>yum -y install yum-plugin-priorities --downloadonly --downloaddir=~/rpmbuild/RPMS/$(uname -m)</code>

<code>yum -y install yum-plugin-priorities</code>

#Install (just update lol)

<code>yum -y update --downloadonly --downloaddir=~/rpmbuild/RPMS/$(uname -m)</code>

<code>yum -y update</code>

#Result

[root@vps1 ~]# git --version

git version 1.9-rc0

[root@vps1 ~]#


