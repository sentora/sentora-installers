#!/usr/bin/env bash

HTTP_CONF_PATH="/etc/httpd/conf/httpd.conf"
HTTP_VARS_PATH="/etc/sysconfig/httpd"
HTTP_SERVICE="httpd"
HTTP_USER="apache"
HTTP_GROUP="apache"
if [[ "$VER" = "7" ]]; then
    # Disable extra modules in centos 7
    disable_file /etc/httpd/conf.modules.d/01-cgi.conf
    disable_file /etc/httpd/conf.modules.d/00-lua.conf
    disable_file /etc/httpd/conf.modules.d/00-dav.conf
else
    disable_file /etc/httpd/conf.d/welcome.conf
    disable_file /etc/httpd/conf.d/webalizer.conf
fi     
