#!/usr/bin/env bash

if [[ "$OS" = "CentOs" ]]; then
    $PACKAGE_INSTALLER php php-devel php-gd php-mbstring php-intl php-mysql php-xml php-xmlrpc
    $PACKAGE_INSTALLER php-mcrypt php-imap  #Epel packages
    PHP_INI_PATH="/etc/php.ini"
    PHP_EXT_PATH="/etc/php.d"
elif [[ "$OS" = "Ubuntu" ]]; then
    $PACKAGE_INSTALLER libapache2-mod-php5 php5-common php5-cli php5-mysql php5-gd php5-mcrypt php5-curl php-pear php5-imap php5-xmlrpc php5-xsl
    if [ "$VER" = "14.04" ]; then
        php5enmod mcrypt  # missing in the package for Ubuntu 14!
    else
        $PACKAGE_INSTALLER php5-suhosin
    fi
    PHP_INI_PATH="/etc/php5/apache2/php.ini"
fi
# Setup php upload dir
mkdir -p $PANEL_DATA/temp
chmod 1777 $PANEL_DATA/temp/
chown -R $HTTP_USER:$HTTP_GROUP $PANEL_DATA/temp/

# Setup php session save directory
mkdir "$PANEL_DATA/sessions"
chown $HTTP_USER:$HTTP_GROUP "$PANEL_DATA/sessions"
chmod 733 "$PANEL_DATA/sessions"
chmod +t "$PANEL_DATA/sessions"

if [[ "$OS" = "CentOs" ]]; then
    # Remove session & php values from apache that cause override
    sed -i "/php_value/d" /etc/httpd/conf.d/php.conf
elif [[ "$OS" = "Ubuntu" ]]; then
    sed -i "s|;session.save_path = \"/var/lib/php5\"|session.save_path = \"$PANEL_DATA/sessions\"|" $PHP_INI_PATH
fi
sed -i "/php_value/d" $PHP_INI_PATH
echo "session.save_path = $PANEL_DATA/sessions;">> $PHP_INI_PATH

# setup timezone and upload temp dir
sed -i "s|;date.timezone =|date.timezone = $tz|" $PHP_INI_PATH
sed -i "s|;upload_tmp_dir =|upload_tmp_dir = $PANEL_DATA/temp/|" $PHP_INI_PATH

# Disable php signature in headers to hide it from hackers
sed -i "s|expose_php = On|expose_php = Off|" $PHP_INI_PATH

# Build suhosin for PHP 5.x which is required by Sentora. 
if [[ "$OS" = "CentOs" || ( "$OS" = "Ubuntu" && "$VER" = "14.04") ]] ; then
    echo -e "\n# Building suhosin"
    if [[ "$OS" = "Ubuntu" ]]; then
        $PACKAGE_INSTALLER php5-dev
    fi
    wget -nv -O suhosin.zip https://github.com/stefanesser/suhosin/archive/suhosin-0.9.36.zip
    unzip -q suhosin.zip
    rm -f suhosin.zip
    cd suhosin-suhosin-0.9.36
    phpize &> /dev/null
    ./configure &> /dev/null
    make &> /dev/null
    make install 
    cd ..
    rm -rf suhosin-suhosin-0.9.36
    if [[ "$OS" = "CentOs" ]]; then 
        echo 'extension=suhosin.so' > $PHP_EXT_PATH/suhosin.ini
    elif [[ "$OS" = "Ubuntu" ]]; then
        sed -i 'N;/default extension directory./a\extension=suhosin.so' $PHP_INI_PATH
    fi	
fi

# Register apache(+php) service for autostart and start it
if [[ "$OS" = "CentOs" ]]; then
    if [[ "$VER" == "7" ]]; then
        systemctl enable "$HTTP_SERVICE.service"
        systemctl start "$HTTP_SERVICE.service"
    else
        chkconfig "$HTTP_SERVICE" on
        "/etc/init.d/$HTTP_SERVICE" start
    fi
fi
