#!/usr/bin/env bash

HTTP_CONF_PATH="/etc/apache2/apache2.conf"
HTTP_VARS_PATH="/etc/apache2/envvars"
HTTP_SERVICE="apache2"
HTTP_USER="www-data"
HTTP_GROUP="www-data"
a2enmod rewrite
