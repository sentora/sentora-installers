%define installdir /tmp/php

Summary: packet zpphp (php) for zpanel compile by andykimpe
Name: zpphp
Version: 5.4.24
Release: 1
License: The PHP license
Group: Applications/Internet
Packager: andykimpe andykimpe@gmail.com
Source0: zpphp-%{version}.tar.bz2
Url: http://www.zpanelcp.com/
BuildRoot: %{_tmppath}/%{name}-buildroot
BuildRequires: zphttpd, bzip2-devel, gmp-devel, apr-util-ldap
Requires: zphttpd, bzip2-devel, gmp-devel, apr-util-ldap
Conflicts: php, php54, php55, php54w, php55w 


%description
packet zpphp (php) for zpanel compile by andykimpe

%prep

%setup -n zpphp-%{version}

%build
cd $HOME/rpmbuild/BUILD/zpphp-%{version}
./buildconf --force
./configure --program-prefix= --prefix=/etc/zpanel/bin/php --exec-prefix=/etc/zpanel/bin/php --bindir=/etc/zpanel/bin/php/bin --sbindir=/etc/zpanel/bin/php/bin --sysconfdir=/etc/zpanel/bin/php --datadir=/etc/zpanel/bin/php/usr/share --includedir=/etc/zpanel/bin/php/usr/include --libdir=/etc/zpanel/bin/php/usr/lib --libexecdir=/etc/zpanel/bin/php/usr/libexec --localstatedir=/etc/zpanel/bin/php/var --sharedstatedir=/etc/zpanel/bin/php/var/lib --mandir=/etc/zpanel/bin/php/usr/share/man --infodir=/etc/zpanel/bin/php/usr/share/info --cache-file=../config.cache --with-libdir=lib64 --with-config-file-path=/etc/zpanel/bin/php --with-config-file-scan-dir=/etc/zpanel/bin/php/php.d --disable-debug --with-pic --disable-rpath --without-pear --with-bz2 --with-freetype-dir=/usr --with-png-dir=/usr --with-xpm-dir=/usr --enable-gd-native-ttf --without-gdbm --with-gettext --with-gmp --with-iconv --with-jpeg-dir=/usr --with-openssl --with-pcre-regex=/usr --with-zlib --with-layout=GNU --enable-exif --enable-ftp  --enable-sockets --enable-sysvsem --enable-sysvshm --enable-sysvmsg --with-kerberos  --enable-shmop --enable-calendar  --with-libxml-dir=/usr --enable-xml  --with-apxs2=/etc/zpanel/bin/httpd/bin/apxs --without-mysql --without-gd --disable-dom --disable-dba --without-unixODBC --disable-pdo --disable-xmlreader --disable-xmlwriter --disable-phar --disable-fileinfo --disable-json --without-pspell --disable-wddx --without-curl --disable-posix --disable-sysvmsg --disable-sysvshm --disable-sysvsem
make
mkdir -p $RPM_BUILD_ROOT/%{installdir}
wget https://github.com/zpanel/installers/raw/master/install/CentOS-6_4/compile/zpphp/php-makefile.patch -qO- | patch -p0

%install
cp -R * $RPM_BUILD_ROOT/%{installdir}


%post
cd %{installdir}
cp php.ini-development /etc/zpanel/bin/php/php.ini 2> /dev/null
make install 2> /dev/null
mkdir -p /etc/zpanel/bin/httpd/conf.d/ 2> /dev/null
wget https://github.com/zpanel/installers/raw/master/install/CentOS-6_4/compile/zpphp/php.conf -q -O /etc/zpanel/bin/httpd/conf.d/php.conf
service zphttpd restart 2> /dev/null


%preun


%postun
rm -rf /etc/zpanel/bin/php
rm -f /etc/zpanel/bin/httpd/conf.d/php.conf
rm -f /etc/zpanel/bin/httpd/modules/libphp5.so

%files
%defattr(777,root,root)
/%{installdir}/*
