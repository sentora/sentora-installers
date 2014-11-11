#!/usr/bin/env bash

# Import roundcube default table
mysql -u root -p"$mysqlpassword" < $PANEL_CONF/sentora-install/sql/sentora_roundcube.sql

# Create and configure mysql password for roundcube
roundcubepassword=$(passwordgen);
sed -i "s|!ROUNDCUBE_PASSWORD!|$roundcubepassword|" $PANEL_CONF/roundcube/db.inc.php
mysql -u root -p"$mysqlpassword" -e "UPDATE mysql.user SET Password=PASSWORD('$roundcubepassword') WHERE User='roundcube' AND Host='localhost'";

# Create and configure des key
roundcube_des_key=$(passwordgen 24);
sed -i "s|!ROUNDCUBE_DESKEY!|$roundcube_des_key|" $PANEL_CONF/roundcube/main.inc.php

# Map config file in roundcube with symbolic links
rm -rf $PANEL_PATH/panel/etc/apps/webmail/config/main.inc.php
ln -s $PANEL_CONF/roundcube/main.inc.php $PANEL_PATH/panel/etc/apps/webmail/config/main.inc.php
ln -s $PANEL_CONF/roundcube/config.inc.php $PANEL_PATH/panel/etc/apps/webmail/plugins/managesieve/config.inc.php
ln -s $PANEL_CONF/roundcube/db.inc.php $PANEL_PATH/panel/etc/apps/webmail/config/db.inc.php
