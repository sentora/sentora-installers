#!/usr/bin/env bash

# Register Bind service for autostart and start it
if [[ "$(sentora_os_ver)" == "7" ]]; then
    systemctl enable named.service
    systemctl start named.service
else
    chkconfig named on
    /etc/init.d/named start
fi
