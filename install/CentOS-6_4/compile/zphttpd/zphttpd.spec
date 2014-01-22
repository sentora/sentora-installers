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
Requires: apr-devel, apr-util-devel, distcache-devel, git, pcre-devel, lua-devel, libxml2-devel

%description
packet httpd apache for zpanel compile by andykimpe

%prep

%setup -n httpd-%{version}

%build
#here add git apr apr-util and finish spec file
git clone https://github.com/apache/apr.git $HOME/rpmbuild/BUILD/httpd-%{version}/srclib/apr
cd $HOME/rpmbuild/BUILD/httpd-%{version}/srclib/apr
git checkout 1.5.0
rm -f configure
./buildconf
mkdir include/private/
./configure --prefix=%{installdir}/apr
make
rm -rf $RPM_BUILD_ROOT/%{installdir}
mkdir -p $RPM_BUILD_ROOT/%{installdir}
make install DESTDIR=$RPM_BUILD_ROOT
make install
cd $HOME/rpmbuild/BUILD/httpd-%{version}
git clone https://github.com/apache/apr-util.git $HOME/rpmbuild/BUILD/httpd-%{version}/srclib/apr-util
cd $HOME/rpmbuild/BUILD/httpd-%{version}/srclib/apr-util
git checkout 1.5.3
rm -f configure
./buildconf
./configure --prefix=%{installdir}/apr-util/  --with-apr=%{installdir}/apr/
make
make install DESTDIR=$RPM_BUILD_ROOT
make install
cd $HOME/rpmbuild/BUILD/httpd-%{version}/
rm -f configure
./buildconf
./configure --prefix=%{installdir}/httpd --exec-prefix=%{installdir}/httpd --enable-mods-shared="all" --enable-rewrite --enable-so --with-apr=%{installdir}/apr/ --with-apr-util=%{installdir}/apr-util/
make
wget https://github.com/zpanel/installers/raw/master/install/CentOS-6_4/compile/zphttpd/zphttpd-init
%install
make install DESTDIR=$RPM_BUILD_ROOT
rm -rf /etc/zpanel/bin/apr
rm -rf /etc/zpanel/bin/apr-util

%post

# here add postinstall apache
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
setenforce 0
sed -i 's/#LoadModule/LoadModule/g' %{installdir}/httpd/conf/httpd.conf
sed -i 's/ServerAdmin you@example.com/ServerAdmin postmaster@$(hostname)/g' %{installdir}/httpd/conf/httpd.conf
sed -i 's/#ServerName www.example.com/ServerName $(hostname)/g' %{installdir}/httpd/conf/httpd.conf
rm -f /etc/init.d/httpd
mv %{installdir}/httpd/zphttpd-init /etc/init.d/httpd
chmod +x /etc/init.d/httpd
chkconfig --add httpd
chkconfig httpd on
service httpd start
service iptables save
service iptables stop
chkconfig iptables off


%preun
# here add postuninstall
chkconfig --del httpd
rm -f /etc/init.d/httpd
%{installdir}/httpd/bin/apachectl -k stop

%files
%defattr(777,root,root)
/%{installdir}/*
