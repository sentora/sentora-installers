dot not use no finish
%define installdir /etc/zpanel/bin/

Summary:                 packet httpd apache for zpanel compile by andykimpe
Name:                    zphttpd
Version:                 2.4.7
Release:                 1
License:                 GPL
Group:                   Applications/Internet
Packager:                andykimpe andykimpe@gmail.com
Source0:                 httpd-2.4.7.tar.gz
Url:                     http://www.zpanelcp.com/
BuildRoot:               %{_tmppath}/%{name}-buildroot
Requires: apr-devel, apr-util-devel, distcache-devel

%description
packet httpd apache for zpanel compile by andykimpe

%prep

%setup -n httpd-2.4.7

%build
#here add git apr apr-util and finish spec file
./configure --prefix=%{installdir}
make

%install
rm -rf $RPM_BUILD_ROOT/%{installdir}
mkdir -p $RPM_BUILD_ROOT/%{installdir}
make install DESTDIR=$RPM_BUILD_ROOT


%post

# here add postinstall apache


%preun
# here add postuninstall


%files
%defattr(777,root,root)
/%{installdir}/*
