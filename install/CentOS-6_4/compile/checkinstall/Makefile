# checkinstall version 1.6.3
install:
	mkdir /opt/checkinstall/
	cp -R ./* /opt/checkinstall/
	rm -f /opt/checkinstall/Makefile
	ln -s /opt/checkinstall/bin/installwatch /usr/bin
	ln -s /opt/checkinstall/sbin/checkinstall /usr/bin
	ln -s /opt/checkinstall/sbin/makepak /usr/bin
uninstall:
	rm -rf /opt/checkinstall/
	rm -f /usr/bin/checkinstall
	rm -f /usr/bin/makepak
