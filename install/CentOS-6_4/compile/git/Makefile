# git version 1.9-rc0
install:
	mkdir /opt/git/
	cp -R ./* /opt/git/
	rm -f /opt/git/Makefile
	ln -s /opt/git/bin/git /usr/bin
	ln -s /opt/git/bin/git-cvsserver /usr/bin
	ln -s /opt/git/bin/gitk /usr/bin
	ln -s /opt/git/bin/git-receive-pack /usr/bin
	ln -s /opt/git/bin/git-shell /usr/bin
	ln -s /opt/git/bin/git-upload-archive /usr/bin
	ln -s /opt/git/bin/git-upload-pack /usr/bin
uninstall:
	rm -rf /opt/git/
	rm -f /usr/bin/git
	rm -f /usr/bin/git-cvsserver
	rm -f /usr/bin/gitk
	rm -f /usr/bin/git-receive-pack
	rm -f /usr/bin/git-shell
	rm -f /usr/bin/git-upload-archive
	rm -f /usr/bin/git-upload-pack
