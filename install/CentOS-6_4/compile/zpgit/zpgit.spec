%define installdir  /etc/zpanel/bin/git

Summary: 		packet git for zpanel compile by andykimpe
Name: 			zpgit
Version: 		1.9.rc0
Release: 		1
License:		GPL
Group: 			Applications/Internet
Packager: 	andykimpe andykimpe@gmail.com
Source0: 		zpgit-1.9-rc0.tar.gz
Url: 			http://www.zpanelcp.com/
BuildRoot: 		%{_tmppath}/%{name}-buildroot
Requires: openssl-devel, perl-devel

%description
packet git for zpanel compile by andykimpe
Obsoletes: git

%prep

%setup -n git-1.9-rc0

%build
make configure
./configure --prefix=%{installdir} --with-ssl=openssl
make

%install
rm -rf $RPM_BUILD_ROOT/%{installdir}
mkdir -p $RPM_BUILD_ROOT/%{installdir}
make install DESTDIR=$RPM_BUILD_ROOT


%post

ln -s %{installdir}/bin/git /usr/bin
ln -s %{installdir}/bin/git-cvsserver /usr/bin
ln -s %{installdir}/bin/gitk /usr/bin
ln -s %{installdir}/bin/git-receive-pack /usr/bin
ln -s %{installdir}/bin/git-shell /usr/bin
ln -s %{installdir}/bin/git-upload-archive /usr/bin
ln -s %{installdir}/bin/git-upload-pack /usr/bin


%preun
rm -f /usr/bin/git
rm -f /usr/bin/git-cvsserver
rm -f /usr/bin/gitk
rm -f /usr/bin/git-receive-pack
rm -f /usr/bin/git-shell
rm -f /usr/bin/git-upload-archive
rm -f /usr/bin/git-upload-pack


%files
%defattr(777,root,root)
/%{installdir}/bin/*
/%{installdir}/lib64/*
/%{installdir}/libexec/*
/%{installdir}/libexec/*
/%{installdir}/share/*
