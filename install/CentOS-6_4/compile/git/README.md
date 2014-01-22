create rpm for git enter command

<code>yum -y install rpm-build rpm-devel wget</code>

<code>mkdir -p ~/rpmbuild/{SOURCES,SPECS,BUILD,RPMS,SRPMS}</code>

<code>yum -y groupinstall "Development Tools"</code>

<code>wget https://github.com/git/git/archive/v1.9-rc0.tar.gz -O ~/rpmbuild/SOURCES/git-1.9-rc0.tar.gz</code>

<code>wget https://github.com/zpanel/installers/raw/master/install/CentOS-6_4/compile/git/git.spec -O ~/rpmbuild/SPECS/git.spec</code>

<code>rpmbuild -ba ~/rpmbuild/SPECS/git.spec</code>
