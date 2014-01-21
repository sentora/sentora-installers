# zphttpd (httpd apache) version 2.4.7 include apr 1.5.0 apr-util 1.5.3
install:
	cp -R ./* /etc/zpanel/bin/
	sed -i 's/#LoadModule/LoadModule/g' /etc/zpanel/bin/httpd/conf/httpd.conf
	sed -i 's/ServerAdmin you@example.com/ServerAdmin postmaster@$(hostname)/g' /etc/zpanel/bin/httpd/conf/httpd.conf
	sed -i 's/#ServerName www.example.com/ServerName $(hostname)/g' /etc/zpanel/bin/httpd/conf/httpd.conf
	rm -f /etc/init.d/httpd
	mv /etc/zpanel/bin/httpd/httpd-init /etc/init.d/httpd
	chmod +x /etc/init.d/httpd
	chkconfig --add httpd
	chkconfig httpd on
	service httpd start
	service iptables save
	service iptables stop
	chkconfig iptables off
uninstall:
	chkconfig --del httpd
	rm -f /etc/init.d/httpd
	/etc/zpanel/bin/httpd/bin/apachectl -k stop
	rm -rf /etc/zpanel/bin/apr
	rm -rf /etc/zpanel/bin/apr-util
	rm -rf /etc/zpanel/bin/httpd
