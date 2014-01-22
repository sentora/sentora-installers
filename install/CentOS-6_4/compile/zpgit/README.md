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

<code>yum -y install http://mirror.webtatic.com/yum/el6/latest.rpm</code>

<code>yum -y update</code>

<code>yum -y install yum-plugin-replace createrepo</code>

<code>cd ~/rpmbuild/RPMS/$(uname -m)</code>

<code>createrepo ./</code>

<code>echo # CentOS-Media.repo > /etc/yum.repos.d/CentOS-Media.repo</code>

<code>echo # yum --enablerepo=c6-media [command] >> /etc/yum.repos.d/CentOS-Media.repo</code>

<code>echo #  yum --disablerepo=\* --enablerepo=c6-media [command] >> /etc/yum.repos.d/CentOS-Media.repo</code>

<code>echo #  [c6-media] >> /etc/yum.repos.d/CentOS-Media.repo</code>

<code>echo #  name=CentOS-6 - Media >> /etc/yum.repos.d/CentOS-Media.repo</code>

<code>echo #  baseurl=file:///root/rpmbuild/RPMS/$basearch >> /etc/yum.repos.d/CentOS-Media.repo</code>

<code>echo #  gpgcheck=0 >> /etc/yum.repos.d/CentOS-Media.repo</code>

<code>echo #  enabled=1 >> /etc/yum.repos.d/CentOS-Media.repo</code>

<code>echo #  priority=1 >> /etc/yum.repos.d/CentOS-Media.repo</code>

<code>yum -y install yum-plugin-priorities</code>

<code>yum -y update</code>

<code>yum replace git --replace-with=zpgit</code>

<code>yum -y localinstall ~/rpmbuild/RPMS/$(uname -m)/zpgit-1.9.rc0-1.$(uname -m).rpm \ </code>

<code>/root/rpmbuild/RPMS/$(uname -m)/zpgit-debuginfo-1.9.rc0-1.$(uname -m).rpm</code>

#Result

[root@vps1 ~]# git --version

git version 1.9-rc0

[root@vps1 ~]#


