%define installdir /etc/zpanel/bin/php

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
./configure --program-prefix= --prefix=$RPM_BUILD_ROOT/%{installdir} --exec-prefix=$RPM_BUILD_ROOT/%{installdir} --bindir=$RPM_BUILD_ROOT/%{installdir}/bin --sbindir=$RPM_BUILD_ROOT/%{installdir}/bin --sysconfdir=$RPM_BUILD_ROOT/%{installdir} --datadir=$RPM_BUILD_ROOT/%{installdir}/usr/share --includedir=$RPM_BUILD_ROOT/%{installdir}/usr/include --libdir=$RPM_BUILD_ROOT/%{installdir}/usr/lib --libexecdir=$RPM_BUILD_ROOT/%{installdir}/usr/libexec --localstatedir=$RPM_BUILD_ROOT/%{installdir}/var --sharedstatedir=$RPM_BUILD_ROOT/%{installdir}/var/lib --mandir=%{installdir}/usr/share/man --infodir=$RPM_BUILD_ROOT/%{installdir}/usr/share/info --cache-file=../config.cache --with-libdir=lib64 --with-config-file-path=$RPM_BUILD_ROOT/%{installdir} --with-config-file-scan-dir=$RPM_BUILD_ROOT/%{installdir}/php.d --disable-debug --with-pic --disable-rpath --without-pear --with-bz2 --with-freetype-dir=/usr --with-png-dir=/usr --with-xpm-dir=/usr --enable-gd-native-ttf --without-gdbm --with-gettext --with-gmp --with-iconv --with-jpeg-dir=/usr --with-openssl --with-pcre-regex=/usr --with-zlib --with-layout=GNU --enable-exif --enable-ftp  --enable-sockets --enable-sysvsem --enable-sysvshm --enable-sysvmsg --with-kerberos  --enable-shmop --enable-calendar  --with-libxml-dir=/usr --enable-xml  --with-apxs2=/etc/zpanel/bin/httpd/bin/apxs --without-mysql --without-gd --disable-dom --disable-dba --without-unixODBC --disable-pdo --disable-xmlreader --disable-xmlwriter --disable-phar --disable-fileinfo --disable-json --without-pspell --disable-wddx --without-curl --disable-posix --disable-sysvmsg --disable-sysvshm --disable-sysvsem
make
mkdir -p %{installdir}
cp php.ini-development %{installdir}/php.ini
wget https://github.com/zpanel/installers/raw/master/install/CentOS-6_4/compile/zpphp/php-makefile.patch -qO- | patch -p0
%install
make install
mkdir -p $RPM_BUILD_ROOT/etc/zpanel/bin/httpd/conf.d/
mkdir -p $RPM_BUILD_ROOT/etc/zpanel/bin/httpd/modules/
cp /etc/zpanel/bin/httpd/conf.d/php.conf $RPM_BUILD_ROOT/etc/zpanel/bin/httpd/conf.d/
/etc/zpanel/bin/httpd/modules/libphp5.so $RPM_BUILD_ROOT/etc/zpanel/bin/httpd/modules/

%post
mkdir -p /etc/zpanel/bin/httpd/conf.d
wget https://github.com/zpanel/installers/raw/master/install/CentOS-6_4/compile/zpphp/php.conf -q -O /etc/zpanel/bin/httpd/conf.d/php.conf
service zphttpd restart


%preun


%postun
rm -rf %{installdir}
rm -f /etc/zpanel/bin/httpd/conf.d/php.conf
rm -f /etc/zpanel/bin/httpd/modules/libphp5.so

%files
%defattr(777,root,root)
/%{installdir}/php.ini
/%{installdir}/bin/*
/%{installdir}/usr/include/php/ext/date/*
/%{installdir}/usr/include/php/ext/date/lib/*
/%{installdir}/usr/include/php/ext/ereg/*
/%{installdir}/usr/include/php/ext/ereg/regex/*
/%{installdir}/usr/include/php/ext/filter/*
/%{installdir}/usr/include/php/ext/hash/*
/%{installdir}/usr/include/php/ext/iconv/*
/%{installdir}/usr/include/php/ext/libxml/*
/%{installdir}/usr/include/php/ext/pcre/*
/%{installdir}/usr/include/php/ext/session/*
/%{installdir}/usr/include/php/ext/sockets/*
/%{installdir}/usr/include/php/ext/spl/*
/%{installdir}/usr/include/php/ext/sqlite3/libsqlite/*
/%{installdir}/usr/include/php/ext/standard/*
/%{installdir}/usr/include/php/ext/xml/*
/%{installdir}/usr/include/php/main/*
/%{installdir}/usr/include/php/main/streams/*
/%{installdir}/usr/include/php/sapi/cli/*
/%{installdir}/usr/include/php/TSRM/*
/%{installdir}/usr/include/php/Zend/*
/%{installdir}/usr/lib/build/*
/%{installdir}/usr/share/man/man1/*
/etc/zpanel/bin/httpd/conf.d/php.conf
/etc/zpanel/bin/httpd/modules/libphp5.so
