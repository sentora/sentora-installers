Create rpm for zphttpd


<code>yum -y install pcre-devel lua-devel libxml2-devel --downloadonly --downloaddir=$HOME/rpmbuild/RPMS/$(uname -m)</code>

<code>yum -y install pcre-devel lua-devel libxml2-devel</code>

<code>wget https://github.com/zpanel/installers/raw/master/install/CentOS-6_4/compile/zphttpd/zphttpd.spec \ </code>

<code>-P $HOME/rpmbuild/SPECS</code>

<code>wget http://www.gtlib.gatech.edu/pub/apache/httpd/httpd-2.4.7.tar.bz2 -P $HOME/rpmbuild/SOURCES</code>

<code>rpmbuild -ba $HOME/rpmbuild/SPECS/zphttpd.spec</code>
