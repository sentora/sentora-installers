#Create rpm for zpmysql

<code>mkdir -p $HOME/rpmbuild/SOURCE/mysql-work</code>

<code>cd $HOME/rpmbuild/SOURCE/mysql-work</code>

<code>wget http://cdn.mysql.com/Downloads/MySQL-5.6/MySQL-5.6.15-1.el6.src.rpm</code>

<code> rpm2cpio MySQL-5.6.15-1.el6.src.rpm  | cpio -idmv</code>
