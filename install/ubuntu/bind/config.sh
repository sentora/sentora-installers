#!/usr/bin/env bash

mysql -u root -p"$mysqlpassword" -e "UPDATE sentora_core.x_settings SET so_value_tx='' WHERE so_name_vc='bind_log'"

mkdir -p /var/named/dynamic
touch /var/named/dynamic/managed-keys.bind
chown -R bind:bind /var/named/
chmod -R 777 $PANEL_CONF/bind/etc

chown root:root $BIND_FILES/rndc.key
chmod 755 $BIND_FILES/rndc.key
