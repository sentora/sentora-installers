#!/usr/bin/env bash

chmod 751 /var/named
chmod 771 /var/named/data
sed -i 's|bind/zones.rfc1918|named.rfc1912.zones|' $PANEL_CONF/bind/named.conf
