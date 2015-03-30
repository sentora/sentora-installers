#!/usr/bin/env bash

#--- Apache server patch
    HTTP_CONF_PATH="/etc/httpd/conf/httpd.conf"
	# Disable more extra modules in centos 6.x /etc/httpd/httpd.conf dav/ldap/cgi/proxy_ajp
	sed -i "s|LoadModule suexec_module modules|#LoadModule suexec_module modules|" "$HTTP_CONF_PATH"
	sed -i "s|LoadModule cgi_module modules|#LoadModule cgi_module modules|" "$HTTP_CONF_PATH"
	sed -i "s|LoadModule dav_module modules|#LoadModule dav_module modules|" "$HTTP_CONF_PATH"
	sed -i "s|LoadModule dav_fs_module modules|#LoadModule dav_fs_module modules|" "$HTTP_CONF_PATH"
	sed -i "s|LoadModule proxy_ajp_module modules|#LoadModule proxy_ajp_module modules|" "$HTTP_CONF_PATH"
