%define pkgmajver %(echo %version | cut -d. -f1-2)
%define pkgminver %(echo %version | cut -d. -f3)
Name:          zpwebalizer
Version:       2.23.08
Release: 1
Summary:       A fast, free web server log file analysis program.
Group:         Applications/Web
Vendor:        openmamba
Distribution:  centos
Packager:      Silvan Calarco <silvan.calarco@...>
URL:           http://webalizer.miscellaneousmirror.org/
Source:        webalizer-2.23-08-src.tgz
Source1:       %{HOME}/rpmbuild/SOURCES/webalizer-conf
Source2:       %{HOME}/rpmbuild/SOURCES/webalizer-crond
License:       GPL
## AUTOBUILDREQ-BEGIN
Requires: zpphp-suhosin
BuildRequires: glibc-devel
BuildRequires: gd-devel
BuildRequires: libpng-devel
## AUTOBUILDREQ-END
BuildRoot:     %{_tmppath}/%{name}-%{version}-root

%description
The Webalizer is a fast, free web server log file analysis program.
It produces highly detailed, easily configurable usage reports in HTML format, for viewing with a standard web browser.

%prep
[ "%{buildroot}" != / ] && rm -rf "%{buildroot}"

%setup -n webalizer-2.23-08

%build

./configure \
   --bindir=%{_bindir} \
   --mandir=%{_mandir}/man1 \
   --sysconfdir=%{_sysconfdir} \
   --with-etcdir=%/etc/zpanel/bin/httpd/conf.d \
   --enable-dns \
   --with-dblib=/usr/lib/ \
   --with-db=/usr/include

make

%install
mkdir -p %{buildroot}%{_bindir}
mkdir -p %{buildroot}%{_sysconfdir}/{httpd,cron.daily}
mkdir -p %{buildroot}%{_mandir}/man1
mkdir -p %{buildroot}/var/www/html/webalizer
make install BINDIR=%{buildroot}%{_bindir} \
MANDIR=%{buildroot}%{_mandir}/man1 \
ETCDIR=%{buildroot}/etc/zpanel/bin/httpd/conf.d
cp %{SOURCE1} %{buildroot}/etc/zpanel/bin/httpd/conf.d/webalizer.conf
cp %{SOURCE2} %{buildroot}%{_sysconfdir}/cron.daily/webalizer

rm %{buildroot}/etc/zpanel/bin/httpd/conf.d/webalizer.conf.sample
rm %{buildroot}%{_bindir}/webazolver
ln -s webalizer %{buildroot}%{_bindir}/webazolver

%clean
[ "%{buildroot}" != / ] && rm -rf "%{buildroot}"

%files
%defattr(-,root,root)
%{_bindir}/wcmgr
%{_bindir}/webazolver
%{_bindir}/webalizer
%{_mandir}/man1/*
%config(noreplace) /etc/zpanel/bin/httpd/conf.d/webalizer.conf
%config(noreplace) %attr(0700,root,root) %{_sysconfdir}/cron.daily/webalizer
%dir %{_localstatedir}/www/html/webalizer
