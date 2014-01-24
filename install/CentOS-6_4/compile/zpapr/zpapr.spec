%define installdir /etc/zpanel/bin/apr

Summary: packet apr for zpanel compile by andykimpe
Name: zpapr
Version: 1.5.0
Release: 1
License: Apache License, Version 2.0
Group: Applications/Internet
Packager: andykimpe andykimpe@gmail.com
Source0: zpapr-1.5.0.tar.bz2
Url: http://www.zpanelcp.com/
BuildRoot: %{_tmppath}/%{name}-buildroot

%description
packet apr for zpanel compile by andykimpe

%prep

%setup -n zpapr-%{version}

%build
cd $HOME/rpmbuild/BUILD/zpapr-%{version}/
rm -f configure
./buildconf
mkdir include/private/
./configure --prefix=%{installdir}
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

