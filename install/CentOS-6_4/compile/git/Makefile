# git version 1.9-rc0
install:
	mkdir /etc/zpanel/bin/git/
	cp -R ./* /etc/zpanel/bin/git/
	rm -f /etc/zpanel/bin/git/Makefile
	ln -s /etc/zpanel/bin/git/bin/git /usr/bin
	ln -s /etc/zpanel/bin/git/bin/git-cvsserver /usr/bin
	ln -s /etc/zpanel/bin/git/bin/gitk /usr/bin
	ln -s /etc/zpanel/bin/git/bin/git-receive-pack /usr/bin
	ln -s /etc/zpanel/bin/git/bin/git-shell /usr/bin
	ln -s /etc/zpanel/bin/git/bin/git-upload-archive /usr/bin
	ln -s /etc/zpanel/bin/git/bin/git-upload-pack /usr/bin
uninstall:
	rm -rf /etc/zpanel/bin/git/
	rm -f /usr/bin/git
	rm -f /usr/bin/git-cvsserver
	rm -f /usr/bin/gitk
	rm -f /usr/bin/git-receive-pack
	rm -f /usr/bin/git-shell
	rm -f /usr/bin/git-upload-archive
	rm -f /usr/bin/git-upload-pack
