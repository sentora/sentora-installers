#Create rpm for wget enter command

<code>wget http://ftp.gnu.org/gnu/wget/wget-1.15.tar.gz -P ~/rpmbuild/SOURCES/</code>

<code>wget https://github.com/zpanel/installers/raw/master/install/CentOS-6_4/compile/wget/wget.spec \ </code>

<code>-P ~/rpmbuild/SPECS/</code>

<code>rpmbuild -ba ~/rpmbuild/SPECS/wget.spec</code>

#Regenerate repo

<code>createrepo --update ~/rpmbuild/RPMS/$(uname -m)</code>

#Install (just update lol)

<code>yum -y update</code>

