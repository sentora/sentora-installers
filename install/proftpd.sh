#!/usr/bin/env bash

if [[ "$OS" = "CentOs" ]]; then
    $PACKAGE_INSTALLER proftpd proftpd-mysql 
    FTP_CONF_PATH='/etc/proftpd.conf'
    sed -i "s|nogroup|nobody|" $PANEL_CONF/proftpd/proftpd-mysql.conf
elif [[ "$OS" = "Ubuntu" ]]; then
    $PACKAGE_INSTALLER proftpd-mod-mysql
    FTP_CONF_PATH='/etc/proftpd/proftpd.conf'
fi

# Create and init proftpd database
mysql -u root -p"$mysqlpassword" < $PANEL_CONF/sentora-install/sql/sentora_proftpd.sql

# Create and configure mysql password for proftpd
proftpdpassword=$(passwordgen);
sed -i "s|!SQL_PASSWORD!|$proftpdpassword|" $PANEL_CONF/proftpd/proftpd-mysql.conf
mysql -u root -p"$mysqlpassword" -e "UPDATE mysql.user SET Password=PASSWORD('$proftpdpassword') WHERE User='proftpd' AND Host='localhost'";

# Assign httpd user and group to all users that will be created
HTTP_UID=$(id -u "$HTTP_USER")
HTTP_GID=$(sed -nr "s/^$HTTP_GROUP:x:([0-9]+):.*/\1/p" /etc/group)
mysql -u root -p"$mysqlpassword" -e "ALTER TABLE sentora_proftpd.ftpuser ALTER COLUMN uid SET DEFAULT $HTTP_UID"
mysql -u root -p"$mysqlpassword" -e "ALTER TABLE sentora_proftpd.ftpuser ALTER COLUMN gid SET DEFAULT $HTTP_GID"
sed -i "s|!SQL_MIN_ID!|$HTTP_UID|" $PANEL_CONF/proftpd/proftpd-mysql.conf

# Setup proftpd base file to call sentora config
rm -f "$FTP_CONF_PATH"
#touch "$FTP_CONF_PATH"
#echo "include $PANEL_CONF/proftpd/proftpd-mysql.conf" >> "$FTP_CONF_PATH";
ln -s "$PANEL_CONF/proftpd/proftpd-mysql.conf" "$FTP_CONF_PATH"

chmod -R 644 $PANEL_DATA/logs/proftpd

# Correct bug from package in Ubutu14.04 which screw service proftpd restart
# see https://bugs.launchpad.net/ubuntu/+source/proftpd-dfsg/+bug/1246245
if [[ "$OS" = "Ubuntu" && "$VER" = "14.04" ]]; then
   sed -i 's|\([ \t]*start-stop-daemon --stop --signal $SIGNAL \)\(--quiet --pidfile "$PIDFILE"\)$|\1--retry 1 \2|' /etc/init.d/proftpd
fi

# Register proftpd service for autostart and start it
if [[ "$OS" = "CentOs" ]]; then
    if [[ "$VER" == "7" ]]; then
        systemctl enable proftpd.service
        systemctl start proftpd.service
    else
        chkconfig proftpd on
        /etc/init.d/proftpd start
    fi
fi
