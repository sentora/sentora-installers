#!/usr/bin/env bash

sed -i "s|DocumentRoot \"/var/www/html\"|DocumentRoot $PANEL_PATH/panel|" "$HTTP_CONF_PATH"

sed -i "s|^\(NameVirtualHost .*$\)|#\1\n# NameVirtualHost is now handled in Sentora vhosts file|" "$HTTP_CONF_PATH"
sed -i 's|^\(Listen .*$\)|#\1\n# Listen is now handled in Sentora vhosts file|' "$HTTP_CONF_PATH"
