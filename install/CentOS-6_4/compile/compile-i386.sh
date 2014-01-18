#/bin/bash
# install all dependencie after
git clone https://github.com/apache/httpd.git httpd-2.4.7
cd httpd-2.4.7
git checkout 2.4.7
cd ..
git clone https://github.com/apache/apr.git httpd-2.4.7/srclib/apr
cd httpd-2.4.7/srclib/apr
git checkout 1.5.0
cd ../../..
git clone https://github.com/apache/apr-util httpd-2.4.7/srclib/apr-util
cd httpd-2.4.7/srclib/apr-util
git checkout 1.5.3
cd ../..
./buildconf
./configure --prefix=/etc/zpanel/bin/httpd --exec-prefix=/etc/zpanel/bin/httpd --enable-mods-shared="all" --enable-rewrite --enable-so
make
make install
sed -i 's|#LoadModule|LoadModule|' "/etc/zpanel/bin/httpd/conf/httpd.conf"
mv /etc/init.d/httpd /etc/init.d/httpd.2.2
wget https://github.com/zpanel/installers/raw/master/install/CentOS-6_4/compile/httpd-init -O /etc/init.d/httpd
chmod +x /etc/init.d/httpd
chkconfig --add httpd
chkconfig httpd on
service httpd start
cd ..
