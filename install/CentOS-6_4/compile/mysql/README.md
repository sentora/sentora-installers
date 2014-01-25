#Create rpm for zpmysql

<code>yum -y install gperf ncurses-devel time cmake libaio-devel</code>

<code>wget http://cdn.mysql.com/Downloads/MySQL-5.6/MySQL-5.6.15-1.el6.src.rpm \ </code>

<code>-P $HOME/rpmbuild/SRPMS/</code>

<code>rpmbuild --rebuild $HOME/rpmbuild/SRPMS/MySQL-5.6.15-1.el6.src.rpm</code>
