%define installdir /etc/zpanel/bin/php/

Summary: packet zpphp-suhosin (php-suhosin) for zpanel compile by andykimpe
Name: zpphp-suhosin
Version: 9.34.dev
Release: 1
License: GPL
Group: Applications/Internet
Packager: andykimpe andykimpe@gmail.com
Source0: zpphp-suhosin-%{version}.tar.bz2
Url: http://www.zpanelcp.com/
BuildRoot: %{_tmppath}/%{name}-buildroot
BuildRequires: zpphp
Requires: zpphp
Conflicts: php-suhosin


%description
packet zpphp-suhosin (php-suhosin) for zpanel compile by andykimpe

%prep

%setup -n zpphp-suhosin-%{version}

%build
cd $HOME/rpmbuild/BUILD/zpphp-suhosin-%{version}
/etc/zpanel/bin/php/bin/phpize
./configure --with-php-config=/etc/zpanel/bin/php/bin/php-config
make


%install
make install
mkdir -p $RPM_BUILD_ROOT/%{installdir}/usr/lib/20100525/
cp %{installdir}/usr/lib/20100525/suhosin.so $RPM_BUILD_ROOT/%{installdir}/usr/lib/20100525/
mkdir -p $RPM_BUILD_ROOT/%{installdir}/php.d
cp suhosin.ini $RPM_BUILD_ROOT/%{installdir}/php.d
rm -f %{installdir}/usr/lib/20100525/suhosin.so %{installdir}/php.d/suhosin.ini

%post
service zphttpd restart


%preun


%postun
rm -f %{installdir}/usr/lib/20100525/suhosin.so %{installdir}/php.d/suhosin.ini

%files
%defattr(777,root,root)
%{installdir}/usr/lib/20100525/suhosin.so
%{installdir}/php.d/suhosin.ini
