%define installdir /etc/zpanel/bin/httpd

Summary:                 packet zphttpd (httpd apache) for zpanel compile by andykimpe
Name:                    zphttpd
Version:                 2.2.26
Release:                 1
License: Apache License, Version 2.0
Group:                   Applications/Internet
Packager:                andykimpe andykimpe@gmail.com
Source0:                 zphttpd-%{version}.tar.bz2
Url:                     http://www.zpanelcp.com/
BuildRoot:               %{_tmppath}/%{name}-buildroot
BuildRequires: git, pcre-devel, lua-devel, libxml2-devel,zpapr, zpapr-util
Requires: git, pcre-devel, lua-devel, libxml2-devel,zpapr, zpapr-util
Conflicts: httpd


%description
packet zphttpd (httpd apache) for zpanel compile by andykimpe

%prep

%setup -n zphttpd-%{version}

%build
cd $HOME/rpmbuild/BUILD/zphttpd-%{version}
rm -f configure
./buildconf --with-apr=$HOME/rpmbuild/BUILD/zpapr-1.5.0 --with-apr-util=$HOME/rpmbuild/BUILD/zpapr-util-1.5.3
./configure --prefix=%{installdir} --exec-prefix=%{installdir} --enable-mods-shared="all" --enable-rewrite --enable-so --with-apr=/etc/zpanel/bin/apr/ --with-apr-util=/etc/zpanel/bin/apr-util/
make
%install
make install DESTDIR=$RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT/etc/init.d/
wget https://github.com/zpanel/installers/raw/master/install/CentOS-6_4/create-rpm-file/zphttpd/zphttpd-init -O $RPM_BUILD_ROOT/etc/init.d/zphttpd

%post
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
setenforce 0
sed -i 's/#LoadModule/LoadModule/g' %{installdir}/conf/httpd.conf
sed -i 's/ServerAdmin you@example.com/ServerAdmin postmaster@$(hostname)/g' %{installdir}/conf/httpd.conf
sed -i 's/#ServerName www.example.com/ServerName $(hostname)/g' %{installdir}/conf/httpd.conf
chmod +x /etc/init.d/zphttpd
chkconfig --add zphttpd
chkconfig zphttpd on
service zphttpd start
service iptables save
service iptables stop
chkconfig iptables off


%preun
chkconfig --del zphttpd
rm -f /etc/init.d/zphttpd
%{installdir}/bin/apachectl -k stop

%postun
rm -rf %{installdir}

%files
%defattr(777,root,root)
/%{installdir}/*
/etc/init.d/zphttpd
