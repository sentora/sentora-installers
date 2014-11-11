#!/usr/bin/env bash

# disable completely sites-enabled/000-default.conf
if [[ "$VER" = "14.04" ]]; then 
    sed -i "s|IncludeOptional sites-enabled|#&|" "$HTTP_CONF_PATH"
else
    sed -i "s|Include sites-enabled|#&|" "$HTTP_CONF_PATH"
fi

sed -i "s|\(Include ports.conf\)|#\1\n# Ports are now handled in Sentora vhosts file|" "$HTTP_CONF_PATH"
disable_file /etc/apache2/ports.conf
