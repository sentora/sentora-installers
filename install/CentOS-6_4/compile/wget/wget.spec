%define installdir /usr

Summary:                 packet wget compile by andykimpe
Name:                    wget
Version:                 1.15
Release:                 1
License:                 GPL
Group:                   Applications/Internet
Packager:                andykimpe andykimpe@gmail.com
Source0:                 wget-1.15.tar.gz
Url:                     http://www.zpanelcp.com/
BuildRoot:               %{_tmppath}/%{name}-buildroot
Requires: openssl-devel

%description
packet wget compile by andykimpe

%prep

%setup -n wget-1.15

%build
./configure --prefix=%{installdir}
make

%install
rm -rf $RPM_BUILD_ROOT/%{installdir}
mkdir -p $RPM_BUILD_ROOT/%{installdir}
make install DESTDIR=$RPM_BUILD_ROOT

%files
%defattr(777,root,root)
/%{installdir}/usr/*
