#!/usr/bin/env bash

mysqlpassword=$(passwordgen);
$PACKAGE_INSTALLER "$DB_PCKG"
if [[ "$OS" = "CentOs" ]]; then
    $PACKAGE_INSTALLER "DB_PCKG-devel" "$DB_PCKG-server" 
    MY_CNF_PATH="/etc/my.cnf"
    if  [[ "$VER" = "7" ]]; then
        DB_SERVICE="mariadb"
    else 
        DB_SERVICE="mysqld"
    fi
elif [[ "$OS" = "Ubuntu" ]]; then
    $PACKAGE_INSTALLER bsdutils libsasl2-modules-sql libsasl2-modules
    if [ "$VER" = "12.04" ]; then
        $PACKAGE_INSTALLER db4.7-util
    fi
    MY_CNF_PATH="/etc/mysql/my.cnf"
    DB_SERVICE="mysql"
fi
service $DB_SERVICE start

# setup mysql root password
mysqladmin -u root password "$mysqlpassword"

# small cleaning of mysql access
mysql -u root -p"$mysqlpassword" -e "DELETE FROM mysql.user WHERE User='root' AND Host != 'localhost'";
mysql -u root -p"$mysqlpassword" -e "DELETE FROM mysql.user WHERE User=''";
mysql -u root -p"$mysqlpassword" -e "FLUSH PRIVILEGES";

# remove test table that is no longer used
mysql -u root -p"$mysqlpassword" -e "DROP DATABASE IF EXISTS test";

# secure SELECT "hacker-code" INTO OUTFILE 
sed -i "s|\[mysqld\]|&\nsecure-file-priv = /var/tmp|" $MY_CNF_PATH

# setup sentora access and core database
sed -i "s|YOUR_ROOT_MYSQL_PASSWORD|$mysqlpassword|" $PANEL_PATH/panel/cnf/db.php
mysql -u root -p"$mysqlpassword" < $PANEL_CONF/sentora-install/sql/sentora_core.sql

# Register mysql/mariadb service for autostart
if [[ "$OS" = "CentOs" ]]; then
    if [[ "$VER" == "7" ]]; then
        systemctl enable "$DB_SERVICE".service
    else
        chkconfig "$DB_SERVICE" on
    fi
fi
