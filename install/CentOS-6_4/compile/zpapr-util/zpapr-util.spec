%define installdir /etc/zpanel/bin/apr-util

Summary: packet zpapr-util for zpanel compile by andykimpe
Name: zpapr-util
Version: 1.5.3
Release: 1
License: Apache License, Version 2.0
Group: Applications/Internet
Packager: andykimpe andykimpe@gmail.com
Source0: zpapr-util-1.5.3.tar.bz2
Url: http://www.zpanelcp.com/
BuildRoot: %{_tmppath}/%{name}-buildroot
Requires: zpapr,expat-devel, libuuid-devel, postgresql-devel, mysql-devel, sqlite-devel, freetds-devel, openldap-devel, nss-devel, unixODBC-devel,

%description
packet zpapr-util for zpanel compile by andykimpe

%prep

%setup -n zpapr-util-%{version}

%build
cd $HOME/rpmbuild/BUILD/zpapr-util-%{version}/
rm -f configure
./buildconf --with-apr=$HOME/rpmbuild/BUILD/zpapr-1.5.0
./configure --prefix=%{installdir} --with-apr=/etc/zpanel/bin/apr/
make

%install
rm -rf $RPM_BUILD_ROOT/%{installdir}
mkdir -p $RPM_BUILD_ROOT/%{installdir}
make install DESTDIR=$RPM_BUILD_ROOT

%post


%preun

%postun
rm -rf %{installdir}

%files
%defattr(777,root,root)
/%{installdir}/*
