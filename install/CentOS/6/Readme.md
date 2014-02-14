#Installing zpanelx 10.1.1 for centos 6.x

<code>sudo yum -y remove qpid-cpp-client</code>

there seems to be a bug with yum excut sudo yum clean all before each yum update

<code>sudo yum clean all</code>

<code>sudo yum -y update</code>

configure your time zone

<code>sudo su -c 'echo "echo \$TZ > /etc/timezone" >> /usr/bin/tzselect'</code>

<code>sudo tzselect</code>

or write your time zone in file /etc/timezone

configure your zpanel domain

<code>sudo hostname yourzpaneldomain</code>


or configure the as hostname during the installation of CentOS


<code>sudo yum -y install http://zpanel-mirror.org/centos/6/RPMS/$(uname -m)/zpanel-release-1.0.0-2.$(uname -m).rpm</code>

there seems to be a bug with yum excut sudo yum clean all before each yum update

<code>sudo yum clean all</code>

<code>sudo yum -y update</code>

<code>sudo yum -y install zpanelx</code>

Info zpanelx default using php 5.3 for install php5.4 read documentation 

https://github.com/zpanel/installers/tree/master/install/CentOS/6/php54

Info zpanelx install extra repo read documentation 

https://github.com/zpanel/installers/tree/master/install/CentOS/6/extra





#Updating zpanelx 10.1.0 to 10.1.1 online for centos 6.x

for check your version use <code>setso --show dbversion</code>

<code>sudo yum -y remove rpmforge-release epel-release rpmfusion-release rpmfusion-free-release \ </code>

<code>rpmfusion-non-free-release remi-release atomic-release elrepo-release latest webtatic-release</code>

<code>sudo mv /etc/php.ini /etc/php.ini.zpanel-update</code>

<code>sudo yum -y remove php*</code>

<code>sudo yum -y install http://zpanel-mirror.org/centos/6/RPMS/$(uname -m)/zpanel-release-1.0.0-1.$(uname -m).rpm</code>

there seems to be a bug with yum excut sudo yum clean all before each yum update

<code>sudo yum clean all</code>

<code>sudo yum -y update</code>

<code>sudo yum -y install zpanelx</code>

source file http://zpanel-mirror.org/centos/6/SRPMS/

Info zpanelx default using php 5.3 for install php5.4 read documentation 

https://github.com/zpanel/installers/tree/master/install/CentOS/6/php54


Info zpanelx install extra repo read documentation 

https://github.com/zpanel/installers/tree/master/install/CentOS/6/extra
