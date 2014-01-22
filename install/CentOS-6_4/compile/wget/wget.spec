Name: wget
Summary: a GNU tool to retrieve to files via HTTP, HTTPS and FTP
Version: 1.15
Release: 1
License: GPL-3.0+
Group: system/utils
Packager: andykimpe andykimpe@gmail.com
URL: http://www.zpanelcp.com
Source0: http://ftp.gnu.org/gnu/wget/wget-%{version}.tar.gz
%description
%{summary}.
%package devel
Summary: Development files of %{name}
Group: Development/Libraries
Requires: %{name} = %{version}-%{release}
%description devel
These are development files of %{name}
 	
%prep
%setup -q
%build
%configure --with-ssl=openssl --disable-debug
make
%install
rm -rf $RPM_BUILD_ROOT/%{installdir}
mkdir -p $RPM_BUILD_ROOT/%{installdir}
make install DESTDIR=$RPM_BUILD_ROOT
%find_lang %{name}
%__rm %{buildroot}%{_infodir}/dir
%__install -d %{buildroot}%{_docdir}/%{name}/
%__install -m644 {AUTHORS,COPYING,MAILING-LIST,NEWS,README} %{buildroot}%{_docdir}/%{name}/
%clean
#%nuke
	
%post
%install_info --info-dir=%{_infodir} %{_infodir}/wget.info.gz
	
%postun
%install_info_delete --info-dir=%{_infodir} %{_infodir}/wget.info.gz
 	
%files -f %{name}.lang
%defattr(-,root,root,-)
%{_bindir}/wget
%config(noreplace) %{_sysconfdir}/wgetrc
%doc %{_docdir}/%{name}/*
%doc %{_mandir}/man1/wget.1.gz
%doc %{_infodir}/wget.info.gz
%changelog
