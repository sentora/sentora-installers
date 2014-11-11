#!/usr/bin/env bash

if [[ "$OS" = "CentOs" ]]; then
    #cronie & crontabs may be missing
    $PACKAGE_INSTALLER crontabs
    CRON_DIR="/var/spool/cron"
    CRON_SERVICE="crond"
elif [[ "$OS" = "Ubuntu" ]]; then
    CRON_DIR="/var/spool/cron/crontabs"
    CRON_SERVICE="cron"
fi
CRON_USER="$HTTP_USER"

# prepare daemon crontab
# sed -i "s|!USER!|$CRON_USER|" "$PANEL_CONF/cron/zdaemon" #it screw update search!#
sed -i "s|!USER!|root|" "$PANEL_CONF/cron/zdaemon"
cp "$PANEL_CONF/cron/zdaemon" /etc/cron.d/zdaemon
chmod 644 /etc/cron.d/zdaemon

# prepare user crontabs
CRON_FILE="$CRON_DIR/$CRON_USER"
mysql -u root -p"$mysqlpassword" -e "UPDATE sentora_core.x_settings SET so_value_tx='$CRON_FILE' WHERE so_name_vc='cron_file'"
mysql -u root -p"$mysqlpassword" -e "UPDATE sentora_core.x_settings SET so_value_tx='$CRON_FILE' WHERE so_name_vc='cron_reload_path'"
mysql -u root -p"$mysqlpassword" -e "UPDATE sentora_core.x_settings SET so_value_tx='$CRON_USER' WHERE so_name_vc='cron_reload_user'"
{
    echo "SHELL=/bin/bash"
    echo "PATH=/sbin:/bin:/usr/sbin:/usr/bin"
    echo ""
} > mycron
crontab -u $HTTP_USER mycron
rm -f mycron

chmod 744 "$CRON_DIR"
chown -R $HTTP_USER:$HTTP_USER "$CRON_DIR"
chmod 644 "$CRON_FILE"

# Register cron and atd services for autostart and start them
if [[ "$OS" = "CentOs" ]]; then
    if [[ "$VER" == "7" ]]; then
        systemctl enable crond.service
        systemctl start crond.service
        systemctl start atd.service
    else
        chkconfig crond on
        /etc/init.d/crond start
        /etc/init.d/atd start
    fi
fi
