%define installdir /etc/zpanel/bin/php

Summary: packet zpphp (php) for zpanel compile by andykimpe
Name: zpphp
Version: 5.4.24
Release: 1
License: The PHP license
Group: Applications/Internet
Packager: andykimpe andykimpe@gmail.com
Source0: zpphp-%{version}.tar.bz2
Url: http://www.zpanelcp.com/
BuildRoot: %{_tmppath}/%{name}-buildroot
BuildRequires: zphttpd, bzip2-devel, gmp-devel, apr-util-ldap
Requires: zphttpd, bzip2-devel, gmp-devel, apr-util-ldap
Conflicts: php, php54, php55, php54w, php55w 


%description
packet zpphp (php) for zpanel compile by andykimpe 

%prep

%setup -n zpphp-%{version}

%build
cd $HOME/rpmbuild/BUILD/zpphp-%{version}
./buildconf --force
./configure --program-prefix= --prefix=%{installdir} --exec-prefix=%{installdir} --bindir=%{installdir}/bin --sbindir=%{installdir}/bin --sysconfdir=%{installdir} --datadir=%{installdir}/usr/share --includedir=%{installdir}/usr/include --libdir=%{installdir}/usr/lib --libexecdir=%{installdir}/usr/libexec --localstatedir=%{installdir}/var --sharedstatedir=%{installdir}/var/lib --mandir=%{installdir}/usr/share/man --infodir=%{installdir}/usr/share/info --cache-file=../config.cache --with-libdir=%{_lib} --with-config-file-path=%{installdir} --with-config-file-scan-dir=%{installdir}/php.d --disable-debug --with-pic --disable-rpath --without-pear --with-bz2 --with-freetype-dir=/usr --with-png-dir=/usr --with-xpm-dir=/usr --enable-gd-native-ttf --without-gdbm --with-gettext --with-gmp --with-iconv --with-jpeg-dir=/usr --with-openssl --with-pcre-regex=/usr --with-zlib --with-layout=GNU --enable-exif --enable-ftp  --enable-sockets --enable-sysvsem --enable-sysvshm --enable-sysvmsg --with-kerberos  --enable-shmop --enable-calendar  --with-libxml-dir=/usr --enable-xml  --with-apxs2=/etc/zpanel/bin/httpd/bin/apxs --without-mysql --without-gd --disable-dom --disable-dba --without-unixODBC --disable-pdo --disable-xmlreader --disable-xmlwriter --disable-phar --disable-fileinfo --disable-json --without-pspell --disable-wddx --without-curl --disable-posix --disable-sysvmsg --disable-sysvshm --disable-sysvsem --with-gettext
make
mkdir -p %{installdir}
cp php.ini-development %{installdir}/php.ini
mkdir -p /etc/zpanel/bin/httpd/conf.d
wget https://github.com/zpanel/installers/raw/master/install/CentOS-6_4/create-rpm-file/zpphp/php.conf -q -O /etc/zpanel/bin/httpd/conf.d/php.conf
cp /etc/zpanel/bin/httpd/conf/httpd.conf /etc/zpanel/bin/httpd/conf/httpd.conf.php-install
%install
make install DESTDIR=$RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT/%{installdir}
cp -R %{installdir}/* $RPM_BUILD_ROOT/%{installdir}
mkdir -p $RPM_BUILD_ROOT/etc/zpanel/bin/httpd/conf.d
cp /etc/zpanel/bin/httpd/conf.d/php.conf $RPM_BUILD_ROOT/etc/zpanel/bin/httpd/conf.d
mkdir -p $RPM_BUILD_ROOT/etc/zpanel/bin/httpd/modules/
cp /etc/zpanel/bin/httpd/modules/libphp5.so $RPM_BUILD_ROOT/etc/zpanel/bin/httpd/modules/
cp %{installdir}/php.ini $RPM_BUILD_ROOT/%{installdir}
rm -f /etc/zpanel/bin/httpd/conf/httpd.conf
mv /etc/zpanel/bin/httpd/conf/httpd.conf.bak /etc/zpanel/bin/httpd/conf/httpd.conf
rm -f /etc/zpanel/bin/httpd/conf/httpd.conf
mv /etc/zpanel/bin/httpd/conf/httpd.conf.php-install /etc/zpanel/bin/httpd/conf/httpd.conf
rm -f /etc/zpanel/bin/httpd/conf.d/php.conf /etc/zpanel/bin/httpd/modules/libphp5.so
rm -rf %{installdir}

%post
mkdir %{installdir}/php.d
cp /etc/zpanel/bin/httpd/conf/httpd.conf /etc/zpanel/bin/httpd/conf/httpd.conf.php-install
echo Include conf.d/*.conf >> /etc/zpanel/bin/httpd/conf/httpd.conf
service zphttpd restart


%preun


%postun
rm -rf %{installdir}
rm -f /etc/zpanel/bin/httpd/conf/httpd.conf
mv /etc/zpanel/bin/httpd/conf/httpd.conf.php-install /etc/zpanel/bin/httpd/conf/httpd.conf
rm -f /etc/zpanel/bin/httpd/conf.d/php.conf /etc/zpanel/bin/httpd/modules/libphp5.so

%files
%defattr(777,root,root)
/%{installdir}/php.ini
/%{installdir}/bin/php
/%{installdir}/bin/php-cgi
/%{installdir}/bin/php-config
/%{installdir}/bin/phpize
/%{installdir}/usr/include/php/ext/date/php_date.h
/%{installdir}/usr/include/php/ext/date/lib/timelib_config.h
/%{installdir}/usr/include/php/ext/date/lib/timelib.h
/%{installdir}/usr/include/php/ext/date/lib/timelib_structs.h
/%{installdir}/usr/include/php/ext/ereg/php_ereg.h
/%{installdir}/usr/include/php/ext/ereg/php_regex.h
/%{installdir}/usr/include/php/ext/ereg/regex/cclass.h
/%{installdir}/usr/include/php/ext/ereg/regex/cname.h
/%{installdir}/usr/include/php/ext/ereg/regex/regex2.h
/%{installdir}/usr/include/php/ext/ereg/regex/regex.h
/%{installdir}/usr/include/php/ext/ereg/regex/utils.h
/%{installdir}/usr/include/php/ext/filter/php_filter.h
/%{installdir}/usr/include/php/ext/hash/php_hash_adler32.h
/%{installdir}/usr/include/php/ext/hash/php_hash_crc32.h
/%{installdir}/usr/include/php/ext/hash/php_hash_fnv.h
/%{installdir}/usr/include/php/ext/hash/php_hash_gost.h
/%{installdir}/usr/include/php/ext/hash/php_hash.h
/%{installdir}/usr/include/php/ext/hash/php_hash_haval.h
/%{installdir}/usr/include/php/ext/hash/php_hash_joaat.h
/%{installdir}/usr/include/php/ext/hash/php_hash_md.h
/%{installdir}/usr/include/php/ext/hash/php_hash_ripemd.h
/%{installdir}/usr/include/php/ext/hash/php_hash_sha.h
/%{installdir}/usr/include/php/ext/hash/php_hash_snefru.h
/%{installdir}/usr/include/php/ext/hash/php_hash_tiger.h
/%{installdir}/usr/include/php/ext/hash/php_hash_types.h
/%{installdir}/usr/include/php/ext/hash/php_hash_whirlpool.h
/%{installdir}/usr/include/php/ext/iconv/php_have_bsd_iconv.h
/%{installdir}/usr/include/php/ext/iconv/php_have_glibc_iconv.h
/%{installdir}/usr/include/php/ext/iconv/php_have_ibm_iconv.h
/%{installdir}/usr/include/php/ext/iconv/php_have_iconv.h
/%{installdir}/usr/include/php/ext/iconv/php_have_libiconv.h
/%{installdir}/usr/include/php/ext/iconv/php_iconv_aliased_libiconv.h
/%{installdir}/usr/include/php/ext/iconv/php_iconv.h
/%{installdir}/usr/include/php/ext/iconv/php_iconv_supports_errno.h
/%{installdir}/usr/include/php/ext/iconv/php_php_iconv_h_path.h
/%{installdir}/usr/include/php/ext/iconv/php_php_iconv_impl.h
/%{installdir}/usr/include/php/ext/libxml/php_libxml.h
/%{installdir}/usr/include/php/ext/pcre/php_pcre.h
/%{installdir}/usr/include/php/ext/session/mod_files.h
/%{installdir}/usr/include/php/ext/session/mod_user.h
/%{installdir}/usr/include/php/ext/session/php_session.h
/%{installdir}/usr/include/php/ext/sockets/php_sockets.h
/%{installdir}/usr/include/php/ext/spl/php_spl.h
/%{installdir}/usr/include/php/ext/spl/spl_array.h
/%{installdir}/usr/include/php/ext/spl/spl_directory.h
/%{installdir}/usr/include/php/ext/spl/spl_dllist.h
/%{installdir}/usr/include/php/ext/spl/spl_engine.h
/%{installdir}/usr/include/php/ext/spl/spl_exceptions.h
/%{installdir}/usr/include/php/ext/spl/spl_fixedarray.h
/%{installdir}/usr/include/php/ext/spl/spl_functions.h
/%{installdir}/usr/include/php/ext/spl/spl_heap.h
/%{installdir}/usr/include/php/ext/spl/spl_iterators.h
/%{installdir}/usr/include/php/ext/spl/spl_observer.h
/%{installdir}/usr/include/php/ext/sqlite3/libsqlite/sqlite3.h
/%{installdir}/usr/include/php/ext/standard/base64.h
/%{installdir}/usr/include/php/ext/standard/basic_functions.h
/%{installdir}/usr/include/php/ext/standard/crc32.h
/%{installdir}/usr/include/php/ext/standard/credits_ext.h
/%{installdir}/usr/include/php/ext/standard/credits.h
/%{installdir}/usr/include/php/ext/standard/credits_sapi.h
/%{installdir}/usr/include/php/ext/standard/crypt_blowfish.h
/%{installdir}/usr/include/php/ext/standard/crypt_freesec.h
/%{installdir}/usr/include/php/ext/standard/css.h
/%{installdir}/usr/include/php/ext/standard/cyr_convert.h
/%{installdir}/usr/include/php/ext/standard/datetime.h
/%{installdir}/usr/include/php/ext/standard/dl.h
/%{installdir}/usr/include/php/ext/standard/exec.h
/%{installdir}/usr/include/php/ext/standard/file.h
/%{installdir}/usr/include/php/ext/standard/flock_compat.h
/%{installdir}/usr/include/php/ext/standard/fsock.h
/%{installdir}/usr/include/php/ext/standard/head.h
/%{installdir}/usr/include/php/ext/standard/html.h
/%{installdir}/usr/include/php/ext/standard/html_tables.h
/%{installdir}/usr/include/php/ext/standard/info.h
/%{installdir}/usr/include/php/ext/standard/md5.h
/%{installdir}/usr/include/php/ext/standard/microtime.h
/%{installdir}/usr/include/php/ext/standard/pack.h
/%{installdir}/usr/include/php/ext/standard/pageinfo.h
/%{installdir}/usr/include/php/ext/standard/php_array.h
/%{installdir}/usr/include/php/ext/standard/php_assert.h
/%{installdir}/usr/include/php/ext/standard/php_browscap.h
/%{installdir}/usr/include/php/ext/standard/php_crypt.h
/%{installdir}/usr/include/php/ext/standard/php_crypt_r.h
/%{installdir}/usr/include/php/ext/standard/php_dir.h
/%{installdir}/usr/include/php/ext/standard/php_dns.h
/%{installdir}/usr/include/php/ext/standard/php_ext_syslog.h
/%{installdir}/usr/include/php/ext/standard/php_filestat.h
/%{installdir}/usr/include/php/ext/standard/php_fopen_wrappers.h
/%{installdir}/usr/include/php/ext/standard/php_ftok.h
/%{installdir}/usr/include/php/ext/standard/php_http.h
/%{installdir}/usr/include/php/ext/standard/php_image.h
/%{installdir}/usr/include/php/ext/standard/php_incomplete_class.h
/%{installdir}/usr/include/php/ext/standard/php_iptc.h
/%{installdir}/usr/include/php/ext/standard/php_lcg.h
/%{installdir}/usr/include/php/ext/standard/php_link.h
/%{installdir}/usr/include/php/ext/standard/php_mail.h
/%{installdir}/usr/include/php/ext/standard/php_math.h
/%{installdir}/usr/include/php/ext/standard/php_metaphone.h
/%{installdir}/usr/include/php/ext/standard/php_rand.h
/%{installdir}/usr/include/php/ext/standard/php_smart_str.h
/%{installdir}/usr/include/php/ext/standard/php_smart_str_public.h
/%{installdir}/usr/include/php/ext/standard/php_standard.h
/%{installdir}/usr/include/php/ext/standard/php_string.h
/%{installdir}/usr/include/php/ext/standard/php_type.h
/%{installdir}/usr/include/php/ext/standard/php_uuencode.h
/%{installdir}/usr/include/php/ext/standard/php_var.h
/%{installdir}/usr/include/php/ext/standard/php_versioning.h
/%{installdir}/usr/include/php/ext/standard/proc_open.h
/%{installdir}/usr/include/php/ext/standard/quot_print.h
/%{installdir}/usr/include/php/ext/standard/scanf.h
/%{installdir}/usr/include/php/ext/standard/sha1.h
/%{installdir}/usr/include/php/ext/standard/streamsfuncs.h
/%{installdir}/usr/include/php/ext/standard/uniqid.h
/%{installdir}/usr/include/php/ext/standard/url.h
/%{installdir}/usr/include/php/ext/standard/url_scanner_ex.h
/%{installdir}/usr/include/php/ext/standard/winver.h
/%{installdir}/usr/include/php/ext/xml/expat_compat.h
/%{installdir}/usr/include/php/ext/xml/php_xml.h
/%{installdir}/usr/include/php/main/build-defs.h
/%{installdir}/usr/include/php/main/fopen_wrappers.h
/%{installdir}/usr/include/php/main/logos.h
/%{installdir}/usr/include/php/main/php_compat.h
/%{installdir}/usr/include/php/main/php_config.h
/%{installdir}/usr/include/php/main/php_content_types.h
/%{installdir}/usr/include/php/main/php_getopt.h
/%{installdir}/usr/include/php/main/php_globals.h
/%{installdir}/usr/include/php/main/php.h
/%{installdir}/usr/include/php/main/php_ini.h
/%{installdir}/usr/include/php/main/php_logos.h
/%{installdir}/usr/include/php/main/php_main.h
/%{installdir}/usr/include/php/main/php_memory_streams.h
/%{installdir}/usr/include/php/main/php_network.h
/%{installdir}/usr/include/php/main/php_open_temporary_file.h
/%{installdir}/usr/include/php/main/php_output.h
/%{installdir}/usr/include/php/main/php_reentrancy.h
/%{installdir}/usr/include/php/main/php_scandir.h
/%{installdir}/usr/include/php/main/php_streams.h
/%{installdir}/usr/include/php/main/php_syslog.h
/%{installdir}/usr/include/php/main/php_ticks.h
/%{installdir}/usr/include/php/main/php_variables.h
/%{installdir}/usr/include/php/main/php_version.h
/%{installdir}/usr/include/php/main/rfc1867.h
/%{installdir}/usr/include/php/main/SAPI.h
/%{installdir}/usr/include/php/main/snprintf.h
/%{installdir}/usr/include/php/main/spprintf.h
/%{installdir}/usr/include/php/main/win32_internal_function_disabled.h
/%{installdir}/usr/include/php/main/win95nt.h
/%{installdir}/usr/include/php/main/streams/php_stream_context.h
/%{installdir}/usr/include/php/main/streams/php_stream_filter_api.h
/%{installdir}/usr/include/php/main/streams/php_stream_glob_wrapper.h
/%{installdir}/usr/include/php/main/streams/php_stream_mmap.h
/%{installdir}/usr/include/php/main/streams/php_stream_plain_wrapper.h
/%{installdir}/usr/include/php/main/streams/php_streams_int.h
/%{installdir}/usr/include/php/main/streams/php_stream_transport.h
/%{installdir}/usr/include/php/main/streams/php_stream_userspace.h
/%{installdir}/usr/include/php/sapi/cli/cli.h
/%{installdir}/usr/include/php/TSRM/readdir.h
/%{installdir}/usr/include/php/TSRM/tsrm_config_common.h
/%{installdir}/usr/include/php/TSRM/tsrm_config.h
/%{installdir}/usr/include/php/TSRM/tsrm_config.w32.h
/%{installdir}/usr/include/php/TSRM/TSRM.h
/%{installdir}/usr/include/php/TSRM/tsrm_nw.h
/%{installdir}/usr/include/php/TSRM/tsrm_strtok_r.h
/%{installdir}/usr/include/php/TSRM/tsrm_virtual_cwd.h
/%{installdir}/usr/include/php/TSRM/tsrm_win32.h
/%{installdir}/usr/include/php/Zend/zend_alloc.h
/%{installdir}/usr/include/php/Zend/zend_API.h
/%{installdir}/usr/include/php/Zend/zend_build.h
/%{installdir}/usr/include/php/Zend/zend_builtin_functions.h
/%{installdir}/usr/include/php/Zend/zend_closures.h
/%{installdir}/usr/include/php/Zend/zend_compile.h
/%{installdir}/usr/include/php/Zend/zend_config.h
/%{installdir}/usr/include/php/Zend/zend_config.nw.h
/%{installdir}/usr/include/php/Zend/zend_config.w32.h
/%{installdir}/usr/include/php/Zend/zend_constants.h
/%{installdir}/usr/include/php/Zend/zend_dtrace.h
/%{installdir}/usr/include/php/Zend/zend_dynamic_array.h
/%{installdir}/usr/include/php/Zend/zend_errors.h
/%{installdir}/usr/include/php/Zend/zend_exceptions.h
/%{installdir}/usr/include/php/Zend/zend_execute.h
/%{installdir}/usr/include/php/Zend/zend_extensions.h
/%{installdir}/usr/include/php/Zend/zend_float.h
/%{installdir}/usr/include/php/Zend/zend_gc.h
/%{installdir}/usr/include/php/Zend/zend_globals.h
/%{installdir}/usr/include/php/Zend/zend_globals_macros.h
/%{installdir}/usr/include/php/Zend/zend.h
/%{installdir}/usr/include/php/Zend/zend_hash.h
/%{installdir}/usr/include/php/Zend/zend_highlight.h
/%{installdir}/usr/include/php/Zend/zend_indent.h
/%{installdir}/usr/include/php/Zend/zend_ini.h
/%{installdir}/usr/include/php/Zend/zend_ini_parser.h
/%{installdir}/usr/include/php/Zend/zend_ini_scanner_defs.h
/%{installdir}/usr/include/php/Zend/zend_ini_scanner.h
/%{installdir}/usr/include/php/Zend/zend_interfaces.h
/%{installdir}/usr/include/php/Zend/zend_istdiostream.h
/%{installdir}/usr/include/php/Zend/zend_iterators.h
/%{installdir}/usr/include/php/Zend/zend_language_parser.h
/%{installdir}/usr/include/php/Zend/zend_language_scanner_defs.h
/%{installdir}/usr/include/php/Zend/zend_language_scanner.h
/%{installdir}/usr/include/php/Zend/zend_list.h
/%{installdir}/usr/include/php/Zend/zend_llist.h
/%{installdir}/usr/include/php/Zend/zend_modules.h
/%{installdir}/usr/include/php/Zend/zend_multibyte.h
/%{installdir}/usr/include/php/Zend/zend_multiply.h
/%{installdir}/usr/include/php/Zend/zend_object_handlers.h
/%{installdir}/usr/include/php/Zend/zend_objects_API.h
/%{installdir}/usr/include/php/Zend/zend_objects.h
/%{installdir}/usr/include/php/Zend/zend_operators.h
/%{installdir}/usr/include/php/Zend/zend_ptr_stack.h
/%{installdir}/usr/include/php/Zend/zend_qsort.h
/%{installdir}/usr/include/php/Zend/zend_signal.h
/%{installdir}/usr/include/php/Zend/zend_stack.h
/%{installdir}/usr/include/php/Zend/zend_static_allocator.h
/%{installdir}/usr/include/php/Zend/zend_stream.h
/%{installdir}/usr/include/php/Zend/zend_string.h
/%{installdir}/usr/include/php/Zend/zend_strtod.h
/%{installdir}/usr/include/php/Zend/zend_ts_hash.h
/%{installdir}/usr/include/php/Zend/zend_types.h
/%{installdir}/usr/include/php/Zend/zend_variables.h
/%{installdir}/usr/include/php/Zend/zend_vm_def.h
/%{installdir}/usr/include/php/Zend/zend_vm_execute.h
/%{installdir}/usr/include/php/Zend/zend_vm.h
/%{installdir}/usr/include/php/Zend/zend_vm_opcodes.h
/%{installdir}/usr/lib/build/acinclude.m4
/%{installdir}/usr/lib/build/config.guess
/%{installdir}/usr/lib/build/config.sub
/%{installdir}/usr/lib/build/libtool.m4
/%{installdir}/usr/lib/build/ltmain.sh
/%{installdir}/usr/lib/build/Makefile.global
/%{installdir}/usr/lib/build/mkdep.awk
/%{installdir}/usr/lib/build/phpize.m4
/%{installdir}/usr/lib/build/run-tests.php
/%{installdir}/usr/lib/build/scan_makefile_in.awk
/%{installdir}/usr/lib/build/shtool
/%{installdir}/usr/share/man/man1/php.1
/%{installdir}/usr/share/man/man1/php-cgi.1
/%{installdir}/usr/share/man/man1/php-config.1
/%{installdir}/usr/share/man/man1/phpize.1
/etc/zpanel/bin/httpd/conf.d/php.conf
/etc/zpanel/bin/httpd/modules/libphp5.so
