#Installing zpanelx 10.1.1 for centos 6.x

<code>sudo yum -y update</code>

configure your time zone

<code>sudo su -c 'echo "echo \$TZ > /etc/timezone" >> /usr/bin/tzselect'</code>
<code>sudo tzselect</code>

or write your time zone in file /etc/timezone

configure your zpanel domain

<code>sudo hostname yourzpaneldomain</code>


or configure the as hostname during the installation of CentOS


<code>sudo yum -y install http://zpanel-mirror.org/centos/6/RPMS/$(uname -m)/zpanel-release-1.0.0-1.$(uname -m).rpm</code>
<code>sudo yum -y update</code>
<code>sudo yum -y install zpanelx</code>





#Updating zpanelx 10.1.0 to 10.1.1 online for centos 6.x

for check your version use <code>setso --show dbversion</code>

<code>sudo yum -y remove rpmforge-release epel-release rpmfusion-release rpmfusion-free-release rpmfusion-non-free-release remi-release atomic-release elrepo-release latest webtatic-release</code>
<code>sudo mv /etc/php.ini /etc/php.ini.zpanel-update</code>
<code>sudo yum -y remove php*</code>
<code>sudo yum -y install http://zpanel-mirror.org/centos/6/RPMS/$(uname -m)/zpanel-release-1.0.0-1.$(uname -m).rpm</code>
<code>sudo yum -y update</code>
<code>sudo yum -y install zpanelx</code>

source file http://zpanel-mirror.org/centos/6/SRPMS/
