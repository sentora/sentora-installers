#!/bin/bash

# Official Sentora Automated Update Script
# =============================================
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# Supported Operating Systems: 
# CentOS 8.*/ Minimal, 
# Ubuntu server 16.04, 18.04, 20.04*/ Minimal,
# 32bit and 64bit
#
# Contributions from:
#
#   Anthony DeBeaulieu (anthony.d@sentora.org
#   Pascal Peyremorte (ppeyremorte@sentora.org)
#   Mehdi Blagui
#   Kevin Andrews (kevin@zvps.uk)
#
#   and all those who participated to this and to previous installers.
#   Thanks to all.

## 
# SENTORA_CORE/UPDATER_VERSION
# master - latest unstable
# 2.0.1 - example stable tag
##

SENTORA_UPDATER_VERSION="master"
SENTORA_PRECONF_VERSION="master"
SENTORA_CORE_VERSION="master"

PANEL_PATH="/etc/sentora"
PANEL_CONF="/etc/sentora/configs"
SENTORA_CORE_UPDATE="$HOME/sentora-core-$SENTORA_PRECONF_VERSION"
SENTORA_PRECONF_UPDATE="$HOME/sentora-installers-$SENTORA_CORE_VERSION"

SENTORA_INSTALLED_DBVERSION=$($PANEL_PATH/panel/bin/setso --show dbversion)
SEN_VER=${SENTORA_INSTALLED_DBVERSION:0:7}
	
#--- Display the 'welcome' splash/user warning info..
echo ""
echo "############################################################################################"
echo "#  Welcome to the Official Sentora v.$SENTORA_UPDATER_VERSION Update script.                                  #"
echo "############################################################################################"
echo ""
echo "############################################################################################"
echo "##  !!! WARNING!!! THIS IS NOT A SCRIPT TO UPGRADE FROM V1.0.3 TO SENTORA V2.0.0           #"
echo "##  !!! This script will UPDATE/RESET v2.0.0 SENTORA CORE SYSTEM FILES                     #"
echo "##  !!! to v.$SENTORA_CORE_VERSION current MASTER DEFAULT.                                                 #"
echo "##  !!! This will NOT delete any THIRD-PARTY MODULES/APPS.                                 #"
echo "##  !!! It is RECOMMENDED to BACKUP your Sentora '/ETC/SENTORA/*' DATA BEFORE just in case #"
echo "##  !!! you have changed core files with a custom setup/config. :-)                        #"
echo "##  !!! WE ARE NOT RESPONSIBLE IF THIS SCRIPT DELETES ANY CUSTOM CORE CODING YOU ADDED.    #" 
echo "############################################################################################"
echo ""

# Check if ready
read -p "Have you read the warning above? Are you ready to Continue? (y/n)?" choice
case "$choice" in 
  y|Y ) echo YES;;
  n|N ) exit;;
  * ) echo YES;
esac

echo -e "\n- Checking that minimal requirements are ok"

# Check if the user is 'root' before updating
if [ $UID -ne 0 ]; then
    echo "Install failed: you must be logged in as 'root' to install."
    echo "Use command 'sudo -i', then enter root password and then try again."
    exit 1
fi

# Ensure the OS is compatible with the launcher
if [ -f /etc/centos-release ]; then
    OS="CentOs"
    VERFULL=$(sed 's/^.*release //;s/ (Fin.*$//' /etc/centos-release)
    VER=${VERFULL:0:1} # return 8*
elif [ -f /etc/lsb-release ]; then
    OS=$(grep DISTRIB_ID /etc/lsb-release | sed 's/^.*=//')
    VER=$(grep DISTRIB_RELEASE /etc/lsb-release | sed 's/^.*=//')
elif [ -f /etc/os-release ]; then
    OS=$(grep -w ID /etc/os-release | sed 's/^.*=//')
    VER=$(grep VERSION_ID /etc/os-release | sed 's/^.*"\(.*\)"/\1/')
else
    OS=$(uname -s)
    VER=$(uname -r)
fi
ARCH=$(uname -m)

echo "- Detected : $OS  $VER  $ARCH"

if [[ "$OS" = "CentOs" && ( "$VER" = "8" ) || 
      "$OS" = "Ubuntu" && ( "$VER" = "16.04" || "$VER" = "18.04" || "$VER" = "20.04" ) ]] ; then
    echo "- Ok."
else
    echo "Sorry, this OS is not supported by Sentora." 
    exit 1
fi

### Ensure that sentora is installed
if [ -d /etc/sentora ]; then
    echo "- Found Sentora, processing..."
else
    echo "Sentora is not installed, aborting..."
    exit 1
fi

### Ensure that sentora v2.0.0 or greater is installed
if [[ "$SEN_VER" = 2.0.0* ]]; then
    echo "- Found Sentora v$SEN_VER, processing..."
else
    echo "Sentora version v2.0.0 is required to use this update script, you have v$SEN_VER. ABORTING..."
    exit 1
fi

# Check for some common packages that we know will affect the installation/operating of Sentora.
if [[ "$OS" = "CentOs" ]] ; then
	if [[ "$VER" = "8" ]] ; then
		PACKAGE_INSTALLER="dnf -y -q install"
		PACKAGE_REMOVER="dnf -y -q remove"
	else
		PACKAGE_INSTALLER="yum -y -q install"
		PACKAGE_REMOVER="yum -y -q remove"
	fi
	
	if  [[ "$VER" = "8" ]]; then
		DB_PCKG="mariadb" &&  echo "DB server will be mariaDB"
		DB_SERVICE="mariadb"
	else 
		DB_PCKG="mysql" && echo "DB server will be mySQL"
		DB_SERVICE="mysql"
	fi
	
	HTTP_PCKG="httpd"
	PHP_PCKG="php"
	BIND_PCKG="bind"
	
	HTTP_SERVICE="httpd"
	BIND_SERVICE="bind"
	CRON_SERVICE="crond"
	
elif [[ "$OS" = "Ubuntu" || "$OS" = "debian" ]]; then
    PACKAGE_INSTALLER="apt-get -yqq install"
    PACKAGE_REMOVER="apt-get -yqq remove"  
	
	DB_PCKG="mysql-server"
    HTTP_PCKG="apache2"
    BIND_PCKG="bind9"
	
	DB_SERVICE="mysql"
    HTTP_SERVICE="apache2"
    BIND_SERVICE="bind9"
	CRON_SERVICE="cron"
	
fi

# Setup repos for each OS ARCH and update systems
if [[ "$OS" = "CentOs" ]]; then
	if [[ "$VER" = "8" ]]; then
		# Clean & clear cache
		yum clean all
		rm -rf /var/cache/yum/*
                
		# Update Centos 8 repos to vault.centos.org   
		sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
		sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
		
		# Install PHP 7+ Repos & enable
		$PACKAGE_INSTALLER yum-utils
		$PACKAGE_INSTALLER epel-release
		#$PACKAGE_INSTALLER http://rpms.remirepo.net/enterprise/remi-release-7.rpm
	fi

elif [[ "$OS" = "Ubuntu" || "$OS" = "debian" ]]; then
	if [[ "$VER" = "16.04" || "$VER" = "18.04" || "$VER" = "20.04" || "$VER" = "8" ]]; then
		echo  -e "\n---Updating $OS $VER  $ARCH system and core files\n"
		apt-get -yqq update
		apt-get -yqq upgrade
		echo -e "\n--Done updating $OS $VER system and core files.\n"
	fi
fi

# ***************************************
# Sentora Installation/Update really starts here
# ***************************************
 	
#--- Set custom logging methods so we create a log file in the current working directory.
logfile=$(date +%Y-%m-%d_%H.%M.%S_sentora_update.log)
touch "$logfile"
exec > >(tee "$logfile")
exec 2>&1

extern_ip="$(wget -qO- http://api.sentora.org/ip.txt)"

echo "Sentora Updater v.$SENTORA_UPDATER_VERSION"
echo "Sentora core v$.SENTORA_CORE_VERSION"
echo ""
echo "Updating Sentora v.$SENTORA_CORE_VERSION at http://$HOSTNAME and IP: $extern_ip"
echo "on server under: $OS  $VER  $ARCH"
uname -a

# Stop Apache Sentora Services to avoid any user issues while updating
echo -e "\n-- Stopping Apache services to avoid issues with connecting users during updating..."
service "$HTTP_SERVICE" stop
echo -e "--- Stopped Apache service $HTTP_SERVICE."

# -------------------------------------------------------------------------------
## Start Updating Sentora Services Below.
# -------------------------------------------------------------------------------

# -------------------------------------------------------------------------------
# Start Snuffleupagus update with lastest version Below
# -------------------------------------------------------------------------------
	
	echo -e "\n-- Updating and configuring Snuffleupagus..."
	
	# Presets to run code
	##### Return PHP 7.x version.
	PHPVERFULL=$(php -r 'echo phpversion();')
	PHPVER=${PHPVERFULL:0:3} # return 7.x
	
	# Prepare for Updating of Snuffleupagus
	echo -e "--- Preparing Snuffleupagus for updates"
	
	# Remove snuffleupagus folder for update/new files
	rm -rf /etc/snuffleupagus
	
	## Install Snuffleupagus
	# Install git
	$PACKAGE_INSTALLER git
	
	#setup PHP_PERDIR in Snuffleupagus.c in src
	mkdir -p /etc/snuffleupagus
	cd /etc || exit
	
	# Clone Snuffleupagus
	git clone https://github.com/jvoisin/snuffleupagus
	
	cd /etc/snuffleupagus/src || exit
		
	sed -i 's|PHP_INI_SYSTEM|PHP_INI_PERDIR|g' snuffleupagus.c
	
	# Update PCRE for CentOs 8 - Fix issue with building Snuffleupagus
	if [[ "$OS" = "CentOs" && (  "$VER" = "8" ) ]]; then
		$PACKAGE_INSTALLER pcre-devel
	elif [[ "$OS" = "Ubuntu" && (  "$VER" = "20.04" ) ]]; then
		$PACKAGE_INSTALLER libpcre3 libpcre3-dev
	fi
	
	# Build Snuffleupagus
	phpize
	./configure --enable-snuffleupagus
	make clean
	make
	make install
	
	cd ~ || exit

# Register apache(+php) service for autostart and start it
if [[ "$OS" = "CentOs" ]]; then
    if [[ "$VER" == "8" ]]; then
        systemctl enable "$HTTP_SERVICE.service"
        systemctl start "$HTTP_SERVICE.service"
    else [[ "$OS" = "Ubuntu" ]];
        chkconfig "$HTTP_SERVICE" on
        "/etc/init.d/$HTTP_SERVICE" start
    fi
fi

# Disable PHP EOL message for snuff in apache evrvars file
if [[ "$OS" = "CentOs" ]]; then

	echo 'will add later for Centos'

else
	echo '' >> /etc/apache2/envvars
	echo '## Hide Snuff PHP EOL warning' >> $PANEL_CONF/apache2/envvars
	echo 'export SP_SKIP_OLD_PHP_CHECK=1' >> $PANEL_CONF/apache2/envvars
fi


# -------------------------------------------------------------------------------
# ProFTPd Below
# -------------------------------------------------------------------------------

# Fix Proftpd using datetime stamp DEFAULT with ZEROS use NULL. Fixes MYSQL 5.7.5+ NO_ZERO_IN_DATE
#mysql -u root -p"$mysqlpassword" < "$SENTORA_PRECONF_UPDATE"/preconf/sentora-update/2-0-0/sql/4-proftpd-datetime-fix.sql


# -------------------------------------------------------------------------------
# Start Sentora Core Updating Below
# -------------------------------------------------------------------------------
# -------------------------------------------------------------------------------
# Start NOW
# -------------------------------------------------------------------------------

##-
##--- Download Sentora Core archive from GitHub
##-

echo -e "\n-- Downloading Sentora CORE Files, Please wait, this may take several minutes, the installer will continue after this is complete!"
# Get latest sentora core
while true; do

	# Sentora REPO
    wget -nv -O sentora_core.zip https://github.com/sentora/sentora-core/archive/$SENTORA_CORE_VERSION.zip
	
    if [[ -f sentora_core.zip ]]; then
        break;
    else
        echo "Failed to download sentora core from Github"
        echo "If you quit now, you can run again the installer later."
        read -r -e -p "Press r to retry or q to quit the installer? " resp
        case $resp in
            [Rr]* ) continue;;
            [Qq]* ) exit 3;;
        esac
    fi 
done

# Unzip Sentora core files
unzip -oq sentora_core.zip

# Remove zip file
rm -rf sentora_core.zip

##-
##--- Download Sentora config archive from GitHub
##-
echo -e "\n-- Downloading Sentora CONFIG Files, Please wait, this may take several minutes, the installer will continue after this is complete!"
while true; do

	# Sentora REPO
    wget -nv -O sentora_preconfig.zip https://github.com/sentora/sentora-installers/archive/$SENTORA_PRECONF_VERSION.zip
		
    if [[ -f sentora_preconfig.zip ]]; then
        break;
    else
        echo "Failed to download sentora preconfig from Github"
        echo "If you quit now, you can run again the installer later."
        read -r -e -p "Press r to retry or q to quit the installer? " resp
        case $resp in
            [Rr]* ) continue;;
            [Qq]* ) exit 3;;
        esac
    fi
done

# Unzip Sentora Preconf files
unzip -oq sentora_preconfig.zip

# Remove zip file
rm -rf sentora_preconfig.zip

##
### Update Sentora Preconf files.
##
echo -e "\n-- Updating Sentora Confing files..."

## Backup configs folder just incase...

if [ ! -d "$PANEL_PATH/configs_bak_2.0.0" ]
then
	echo -e "\nBacking up configs files. Just in case..."
	cp -r $PANEL_CONF $PANEL_PATH/configs_bak_2.0.0
fi

## Update Sentora Apache httpd file.
rm -r $PANEL_CONF/apache/httpd.conf
cp -r "$SENTORA_PRECONF_UPDATE"/preconf/apache/httpd.conf $PANEL_CONF/apache/
chmod -R 0644 $PANEL_PATH/configs/apache/httpd.conf

## Updating Sentora Apache Template Configs
rm -rf PANEL_CONF/apache/templates
cp -r "$SENTORA_PRECONF_UPDATE"/preconf/apache/templates $PANEL_CONF/apache/

# Set templates folder to 0755 permissions
chmod -R 0755 $PANEL_CONF/apache/templates

# Set templates to 0644 permissions
chmod -R 0644 $PANEL_CONF/apache/templates/*

## Updating Logrotate Configs
rm -rf PANEL_CONF/logrotate
cp -r "$SENTORA_PRECONF_UPDATE"/preconf/logrotate $PANEL_CONF/

# Set logrotate folder to 0755 permissions
chmod -R 0755 $PANEL_CONF/logrotate

# Set logrotate files to 0644 permissions
chmod -R 0644 $PANEL_CONF/logrotate/*

## Update Sentora Snuff configs files
rm -rf $PANEL_CONF/php/sp
cp -r "$SENTORA_PRECONF_UPDATE"/preconf/php/sp $PANEL_CONF/php/

## Update PHPmyadmin config HTTP to use Cookie and update [hide_db]
sed -i 's|'03/07/2014'|'09/07/2023'|g' $PANEL_CONF/phpmyadmin/config.inc.php
sed -i 's|'http'|'cookie'|g' $PANEL_CONF/phpmyadmin/config.inc.php
sed -i "s|\['hide_db'\] \= 'information_schema';|\['hide_db'\] \= '\^\(information_schema\|sys\|performance_schema\)\$';|" /etc/sentora/configs/phpmyadmin/config.inc.php

echo -e "\n--- Done updating Config files!"

##
### Updating Sentora Core files.
##
echo -e "\n-- Updating Sentora Core files..."

# Update Sentora Dryden files
rm -rf $PANEL_PATH/panel/dryden
cp -r "$SENTORA_CORE_UPDATE"/dryden $PANEL_PATH/panel/

# Update Sentora Static error files
rm -rf $PANEL_PATH/panel/etc/static
cp -r "$SENTORA_CORE_UPDATE"/etc/static $PANEL_PATH/panel/etc/

# Set Dryden to 0777 permissions
chmod -R 0777 $PANEL_PATH/panel/dryden

# Update Zppy code
rm -rf $PANEL_PATH/panel/bin/zppy
cp -r "$SENTORA_CORE_UPDATE"/bin/zppy $PANEL_PATH/panel/bin/
chmod -R 0777 $PANEL_PATH/panel/bin/zppy

# Added New modules - AutoIP, Sencrypt, User Logviewer
# Add sentora repo
zppy repo add repo.sentora.org/repo
zppy update

# Install/Upgrade AutpIP
if [ ! -d "$PANEL_PATH/panel/modules/autoip" ] 
then
	# Install
	echo -e "\nInstalling AutoIP module"
    	zppy install autoip 
else
	# Upgrade
	echo -e "\nUpgrading AutoIP module"
	zppy upgrade autoip
fi

# Install/Upgrade Sencrypt
if [ ! -d "$PANEL_PATH/panel/modules/sencrypt" ] 
then
	# Install
	echo -e "\nInstalling Sencrypt module"
    	zppy install sencrypt 
else
	# Upgrade
	echo -e "\nUpgrading Sencrypt module"
	zppy upgrade sencrypt
fi

# Install/Upgrade User Log Veiwer
if [ ! -d "$PANEL_PATH/panel/modules/user_logviewer" ] 
then
	# Install
	echo -e "\nInstalling User Log Veiwer module"
    	zppy install user_logviewer 
else
	# Upgrade
	echo -e "\nUpgrading User Log Veiwer module"
	zppy upgrade user_logviewer
fi

# Delete All Default core modules for updates. Leave Third-party - There might be a better way to do this.
    ## Removing core Modules for upgrade
    # rm -rf $PANEL_PATH/panel/bin/
    # rm -rf $PANEL_PATH/panel/dryden/
    # rm -rf $PANEL_PATH/panel/etc/
    # rm -rf $PANEL_PATH/panel/inc/
    # rm -rf $PANEL_PATH/panel/index.php
    # rm -rf $PANEL_PATH/panel/LICENSE.md
    # rm -rf $PANEL_PATH/panel/README.md
    # rm -rf $PANEL_PATH/panel/robots.txt
    rm -rf $PANEL_PATH/panel/modules/aliases
    rm -rf $PANEL_PATH/panel/modules/apache_admin
    rm -rf $PANEL_PATH/panel/modules/autoip
    rm -rf $PANEL_PATH/panel/modules/backup_admin
    rm -rf $PANEL_PATH/panel/modules/backupmgr
    rm -rf $PANEL_PATH/panel/modules/client_notices
    rm -rf $PANEL_PATH/panel/modules/cron
    rm -rf $PANEL_PATH/panel/modules/distlists
    rm -rf $PANEL_PATH/panel/modules/dns_admin
    rm -rf $PANEL_PATH/panel/modules/dns_manager
    rm -rf $PANEL_PATH/panel/modules/domains
    rm -rf $PANEL_PATH/panel/modules/faqs
    rm -rf $PANEL_PATH/panel/modules/forwarders
    rm -rf $PANEL_PATH/panel/modules/ftp_admin
    rm -rf $PANEL_PATH/panel/modules/ftp_management
    rm -rf $PANEL_PATH/panel/modules/mail_admin
    rm -rf $PANEL_PATH/panel/modules/mailboxes
    rm -rf $PANEL_PATH/panel/modules/manage_clients
    rm -rf $PANEL_PATH/panel/modules/manage_groups
    rm -rf $PANEL_PATH/panel/modules/moduleadmin
    rm -rf $PANEL_PATH/panel/modules/my_account
    rm -rf $PANEL_PATH/panel/modules/mysql_databases
    rm -rf $PANEL_PATH/panel/modules/mysql_users
    rm -rf $PANEL_PATH/panel/modules/news
    rm -rf $PANEL_PATH/panel/modules/packages
    rm -rf $PANEL_PATH/panel/modules/parked_domains
    rm -rf $PANEL_PATH/panel/modules/password_assistant
    rm -rf $PANEL_PATH/panel/modules/phpinfo
    rm -rf $PANEL_PATH/panel/modules/phpmyadmin
    rm -rf $PANEL_PATH/panel/modules/phpsysinfo
    rm -rf $PANEL_PATH/panel/modules/protected_directories
    rm -rf $PANEL_PATH/panel/modules/sentoraconfig
    rm -rf $PANEL_PATH/panel/modules/sencrypt
    rm -rf $PANEL_PATH/panel/modules/services
    rm -rf $PANEL_PATH/panel/modules/shadowing
    rm -rf $PANEL_PATH/panel/modules/sub_domains
    rm -rf $PANEL_PATH/panel/modules/theme_manager
    rm -rf $PANEL_PATH/panel/modules/updates
    rm -rf $PANEL_PATH/panel/modules/usage_viewer
	rm -rf $PANEL_PATH/panel/modules/user_logviewer
	
    # Need to backup webalizer data first
    # Backup Stats data folder and delete module
    cp -r $PANEL_PATH/panel/modules/webalizer_stats $PANEL_PATH/panel/modules/webalizer_stats_backup
    rm -rf $PANEL_PATH/panel/modules/webalizer_stats
   
    rm -rf $PANEL_PATH/panel/modules/webmail
    rm -rf $PANEL_PATH/panel/modules/zpanelconfig
    rm -rf $PANEL_PATH/panel/modules/zpx_core_module
	
# Updating all modules with new files from master core.
cp -r "$SENTORA_CORE_UPDATE"/modules/* $PANEL_PATH/panel/modules/

# Set all modules to 0777 permissions
chmod -R 0777 $PANEL_PATH/panel/modules/*
echo -e "\n--- Done updating core files!\n"

# Restore webalizer stats data and delete backup
cp -r $PANEL_PATH/panel/modules/webalizer_stats_backup/stats $PANEL_PATH/panel/modules/webalizer_stats/
rm -rf $PANEL_PATH/panel/modules/webalizer_stats_backup

# -------------------------------------------------------------------------------
# Update Sentora APACHE_CHANGED, DBVERSION and run DAEMON
# -------------------------------------------------------------------------------

# Set dbversion
$PANEL_PATH/panel/bin/setso --set dbversion "$SENTORA_CORE_VERSION"

# Set apache daemon to build vhosts file.
$PANEL_PATH/panel/bin/setso --set apache_changed "true"
	
# Run Daemon
echo -e "-- Running Sentora Daemon..."
php -d "sp.configuration_file=/etc/sentora/configs/php/sp/sentora.rules" -q $PANEL_PATH/panel/bin/daemon.php		
echo ""

# Clean up files needed for install/update
rm -rf sentora-core-$SENTORA_CORE_VERSION
rm -rf sentora-installers-$SENTORA_PRECONF_VERSION

#Remove old dev master files and BETA FILES
OLDDEVFILES=$PANEL_PATH/sentora-core
if [ -d "$OLDDEVFILES"* ]; then
    rm -r $PANEL_PATH/sentora-core*
fi
SECURITYCHECKFILE=$PANEL_PATH/panel/sentora_modules_security_check_list.txt
if [ -f "$SECURITYCHECKFILE" ]; then
    rm -r $PANEL_PATH/panel/sentora_modules_security_check_list.txt
fi

echo -e "# -------------------------------------------------------------------------------"
echo -e "-- Restarting Services..."
echo -e "# -------------------------------------------------------------------------------"

#--- Restart all services to capture output messages, if any
if [[ "$OS" = "CentOs" && "$VER" == "8" ]]; then
    # CentOs7 does not return anything except redirection to systemctl :-(
    service() {
       echo "Restarting $1"
       systemctl restart "$1.service"
    }
fi

echo -e "\n--- Restarting Services..."
echo -e "Restarting $DB_SERVICE..."
service "$DB_SERVICE" restart
echo -e "Restarting $HTTP_SERVICE..."
service "$HTTP_SERVICE" restart
echo -e "Restarting Postfix..."
service postfix restart
echo -e "Restarting Dovecot..."
service dovecot restart
echo -e "Restarting CRON..."
service "$CRON_SERVICE" restart
echo -e "Restarting Bind9/Named..."
service "$BIND_SERVICE" restart
echo -e "Restarting Proftpd..."
service proftpd restart
echo -e "Restarting ATD..."
service atd restart

echo -e "-- Finished Restarting Services..."

echo -e "\n# -------------------------------------------------------------------------------"

echo -e "\n-- Done Updating all Sentora core files & services to v.$SENTORA_CORE_VERSION. Enjoy!\n"

# Wait until the user have read before restarts the server...
if [[ "$INSTALL" != "auto" ]] ; then
    while true; do
		
        read -r -e -p "Restart your server now to complete the install (y/n)? " rsn
        case $rsn in
            [Yy]* ) break;;
            [Nn]* ) exit;
        esac
    done
    shutdown -r now
fi