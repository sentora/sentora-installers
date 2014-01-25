#Create rpm for git enter command

<code>mkdir -p $HOME/rpmbuild/{SOURCES,SPECS,BUILD,RPMS/$(uname -m),SRPMS}</code>

<code>yum -y update</code>

<code>yum -y install wget openssl-devel zlib-devel perl-devel</code>

<code>yum -y groupinstall "Development Tools"</code>

<code>yum -y install curl-devel expat-devel xmlto asciidoc</code>

<code>wget https://github.com/git/git/archive/v1.9-rc0.tar.gz -O $HOME/rpmbuild/SOURCES/git-1.9-rc0.tar.gz</code>

<code>wget https://github.com/zpanel/installers/raw/master/install/CentOS-6_4/compile/git/git.spec \ </code>

<code>-P $HOME/rpmbuild/SPECS/</code> 

<code>rpmbuild -ba $HOME/rpmbuild/SPECS/git.spec</code>

#Create repo

<code>yum -y install createrepo</code>

<code>createrepo $HOME/rpmbuild/RPMS/$(uname -m)</code>

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

<code>yum -y install yum-plugin-priorities</code>

#Install (just update lol)

<code>yum -y update</code>

#Result

[root@vps1 ~]# git --version

git version 1.9-rc0

[root@vps1 ~]#


