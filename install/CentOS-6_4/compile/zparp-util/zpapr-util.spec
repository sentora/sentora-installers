%define installdir /etc/zpanel/bin/apr-util

Summary: packet apr-util for zpanel compile by andykimpe
Name: zpapr-util
Version: 1.5.3
Release: 1
License: GPL
Group: Applications/Internet
Packager: andykimpe andykimpe@gmail.com
Source0: apr-util-1.5.3.tar.bz2
Url: http://www.zpanelcp.com/
BuildRoot: %{_tmppath}/%{name}-buildroot

%description
packet apr-util for zpanel compile by andykimpe

%prep

%setup -n apr-util-%{version}

%build
cd $HOME/rpmbuild/BUILD/apr-util-%{version}/
rm -f configure
./buildconf
./configure --prefix=%{installdir} --with-apr=/etc/zpanel/bin/apr/
make

%install
rm -rf $RPM_BUILD_ROOT/%{installdir}
mkdir -p $RPM_BUILD_ROOT/%{installdir}
make install DESTDIR=$RPM_BUILD_ROOT

%post


%preun

%files
%defattr(777,root,root)
/%{installdir}/*
