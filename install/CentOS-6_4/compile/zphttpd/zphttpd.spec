dot not use no finish
%define installdir /etc/zpanel/bin/

Summary:                 packet httpd apache for zpanel compile by andykimpe
Name:                    zphttpd
Version:                 2.4.7
Release:                 1
License:                 GPL
Group:                   Applications/Internet
Packager:                andykimpe andykimpe@gmail.com
Source0:                 httpd-2.4.7.tar.bz2
Url:                     http://www.zpanelcp.com/
BuildRoot:               %{_tmppath}/%{name}-buildroot
Requires: apr-devel, apr-util-devel, distcache-devel, zpgit

%description
packet httpd apache for zpanel compile by andykimpe

%prep

%setup -n httpd-2.4.7

%build
#here add git apr apr-util and finish spec file
git clone https://github.com/apache/apr.git /srclib/apr
cd /srclib/apr
git checkout 1.5.0
rm -f configure
./buildconf
mkdir include/private/
./configure --prefix=%{installdir}/apr
make
rm -rf $RPM_BUILD_ROOT/%{installdir}
mkdir -p $RPM_BUILD_ROOT/%{installdir}
make install DESTDIR=$RPM_BUILD_ROOT
cd ../..
git clone http://192.168.42.1/andykimpe/apr-util.git srclib/apr-util
cd srclib/apr-util
git checkout 1.5.3
rm -f configure
./buildconf
./configure --prefix=%{installdir}/apr-util/  --with-apr=%{installdir}/apr/
make
make install DESTDIR=$RPM_BUILD_ROOT
cd ..
rm -f configure
./buildconf
./configure --prefix=%{installdir}/httpd --exec-prefix=%{installdir}/httpd --enable-mods-shared="all" --enable-rewrite --enable-so --with-apr=%{installdir}/apr/ --with-apr-util=%{installdir}/apr-util/
make
%install
make install DESTDIR=$RPM_BUILD_ROOT


%post

# here add postinstall apache


%preun
# here add postuninstall


%files
%defattr(777,root,root)
/%{installdir}/*
