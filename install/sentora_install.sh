#!/usr/bin/env bash

# Official Sentora Automated Installation Script
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
# Supported Operating Systems: CentOS 6.*/7.* Minimal, Ubuntu server 12.04/14.04 
#  32bit and 64bit
#
#  Author Pascal Peyremorte (ppeyremorte@sentora.org)
#    (main merge of all installers, modularization, reworks and comments)
#  With huge help and contributions from Mehdi Blagui, Kevin Andrews and 
#  all those who participated to this and to previous installers.
#  Thanks to all.

SENTORA_INSTALLER_VERSION="1.0.0-beta9"
SENTORA_CORE_VERSION="1.0.0-beta10"
SENTORA_PRECONF_VERSION="1.0.0-beta9"

PANEL_PATH="/etc/sentora"
PANEL_DATA="/var/sentora"

SCRIPTS=$(dirname $0)
source $SCRIPTS/inc.sh

#--- Display the 'welcome' splash/user warning info..
echo ""
echo "############################################################"
echo "#  Welcome to the Official Sentora Installer $SENTORA_INSTALLER_VERSION  #"
echo "############################################################"

echo -e "\nChecking that minimal requirements are ok"


# Ensure the OS is compatible with the launcher
OS=$(sentora_os)
VER=$(sentora_os_ver)
ARCH=$(uname -m)

echo "Detected : $OS  $VER  $ARCH"

if [[ "$OS" = "CentOs" && ("$VER" = "6" || "$VER" = "7" ) || 
      "$OS" = "Ubuntu" && ("$VER" = "12.04" || "$VER" = "14.04" ) ]] ; then 
    echo "Ok."
else
    echo "Sorry, this OS is not supported by Sentora." 
    exit 1
fi

if [[ "$ARCH" == "i386" || "$ARCH" == "i486" || "$ARCH" == "i586" || "$ARCH" == "i686" ]]; then
    ARCH="i386"
elif [[ "$ARCH" != "x86_64" ]]; then
    echo "Unexpected architecture name was returned ($ARCH ). :-("
    echo "The installer have been designed for i[3-6]8- and x86_6' architectures. If you"
    echo " think it may work on your, please report it to the Sentora forum or bugtracker."
    exit 1
fi

# Check if the user is 'root' before allowing installation to commence
if [ $UID -ne 0 ]; then
    echo "Install failed: you must be logged in as 'root' to install."
    echo "Use command 'sudo -i', then enter root password and then try again."
    exit 1
fi

# Select modules that will be checked before start
if [[ "$OS" = "CentOs" ]] ; then
    PACKAGE_INSTALLER="yum -y -q install"
    PACKAGE_REMOVER="yum -y -q remove"

    if  [[ "$VER" = "7" ]]; then
        DB_PCKG="mariadb" &&  echo "DB server will be mariaDB"
    else 
        DB_PCKG="mysql" && echo "DB server will be mySQL"
    fi
    HTTP_PCKG="httpd"
    PHP_PCKG="php"
    BIND_PCKG="bind"
elif [[ "$OS" = "Ubuntu" ]]; then
    PACKAGE_INSTALLER="apt-get -yqq install"
    PACKAGE_REMOVER="apt-get -yqq remove"
    
    DB_PCKG="mysql-server"
    HTTP_PCKG="apache2"
    PHP_PCKG="apache2-mod-php5"
    BIND_PCKG="bind9"
fi
  
# Check for some common control panels that we know will affect the installation/operating of Sentora.
if [ -e /usr/local/cpanel ] || [ -e /usr/local/directadmin ] || [ -e /usr/local/solusvm/www ] || [ -e /usr/local/home/admispconfig ] || [ -e /usr/local/lxlabs/kloxo ] ; then
    echo "It appears that a control panel is already installed on your server; This installer"
    echo "is designed to install and configure Sentora on a clean OS installation only."
    echo -e "\nPlease re-install your OS before attempting to install using this script."
    exit 1
fi

# Check for some common packages that we know will affect the installation/operating of Sentora.
# We expect a clean OS so no apache/mySQL/bind/postfix/php!
if [[ "$OS" = "CentOs" ]] ; then
    inst() {
       rpm -q "$1" &> /dev/null
    }
elif [[ "$OS" = "Ubuntu" ]]; then
    inst() {
       dpkg -l "$1" 2> /dev/null | grep '^ii' &> /dev/null
    }
fi

# Note : Postfix is installed by default on centos netinstall / minimum install.
# The installer seems to work fine even if Postfix is already installed.
# -> The check of postfix is removed, but this comment remains to remember
for package in "$DB_PCKG" "dovecot-mysql" "$HTTP_PCKG" "$PHP_PCKG" "proftpd" "$BIND_PCKG" ; do
    if (inst "$package"); then
        echo "It appears that package $package is already installed. This installer"
        echo "is designed to install and configure Sentora on a clean OS installation only!"
        echo -e "\nPlease re-install your OS before attempting to install using this script."
        exit 1
    fi
done

# *************************************************
#--- Prepare or query informations required to install

# Install wget and util used to grab server IP, and get server IPs
$PACKAGE_INSTALLER wget 
if [[ "$OS" = "CentOs" ]]; then
    $PACKAGE_INSTALLER bind-utils
elif [[ "$OS" = "Ubuntu" ]]; then
    $PACKAGE_INSTALLER dnsutils
fi
extern_ip="$(wget -qO- http://api.sentora.org/ip.txt)"
local_ip=$(ifconfig eth0 | sed -En 's|.*inet [^0-9]*(([0-9]*\.){3}[0-9]*).*$|\1|p')

# Enable parameters to be entered on commandline, required for vagrant install
#   -d <panel-domain>
#   -i <server-ip> (or -i local or -i public, see below)
#   -t <timezone-string>
# like :
#   sentora_install.sh -t Europe/Paris -d panel.domain.tld -i xxx.xxx.xxx.xxx
# notes:
#   -d and -i must be both present or both absent
#   -i local  force use of local detected ip
#   -i public  force use of public detected ip
#   if -t is used without -d/-i, timezone is set from value given and not asked to user
#   if -t absent and -d/-i are present, timezone is not set at all

# Installer parameters
while getopts d:i:t: opt; do
  case $opt in
  d)
      PANEL_FQDN=$OPTARG
      INSTALL="auto"
      ;;
  i)
      PUBLIC_IP=$OPTARG
      if [[ "$PUBLIC_IP" == "local" ]] ; then
          PUBLIC_IP=$local_ip
      elif [[ "$PUBLIC_IP" == "public" ]] ; then
          PUBLIC_IP=$extern_ip
      fi
      ;;
  t)
      echo "$OPTARG" > /etc/timezone
      tz=$(cat /etc/timezone)
      ;;
  esac
done
if [[ ("$PANEL_FQDN" != "" && "$PUBLIC_IP" == "") || 
      ("$PANEL_FQDN" == "" && "$PUBLIC_IP" != "") ]] ; then
    echo "-d and -i must be both present or both absent."
    exit 2
fi


if [[ "$tz" == "" && "$PANEL_FQDN" == "" ]] ; then
    # Propose selection list for the time zone
    echo "Preparing to select timezone, please wait a few seconds..."
    $PACKAGE_INSTALLER tzdata
    # setup server timezone
    if [[ "$OS" = "CentOs" ]]; then
        # make tzselect to save TZ in /etc/timezone
        echo "echo \$TZ > /etc/timezone" >> /usr/bin/tzselect
        tzselect
        tz=$(cat /etc/timezone)
    elif [[ "$OS" = "Ubuntu" ]]; then
        dpkg-reconfigure tzdata
        tz=$(cat /etc/timezone)
    fi
fi
# clear timezone information to focus user on important notice
clear

# Get subdomain/IP info from user
sentora_mod 'fqdn'

# ***************************************
# Installation really starts here

#--- Set custom logging methods so we create a log file in the current working directory.
logfile=$(date +%Y-%m-%d_%H.%M.%S_sentora_install.log)
touch "$logfile"
exec > >(tee "$logfile")
exec 2>&1

echo "Installer version $SENTORA_INSTALLER_VERSION"
echo "Sentora core version $SENTORA_CORE_VERSION"
echo "Sentora preconf version $SENTORA_PRECONF_VERSION"
echo ""
echo "Installing Sentora $SENTORA_CORE_VERSION at http://$PANEL_FQDN and ip $PUBLIC_IP"
echo "on server under: $OS  $VER  $ARCH"
uname -a

# Function to disable a file by appending its name with _disabled
disable_file() {
    mv "$1" "$1_disabled_by_sentora" &> /dev/null
}

#--- AppArmor must be disabled to avoid problems
if [[ "$OS" = "Ubuntu" ]]; then
    [ -f /etc/init.d/apparmor ]
    if [ $? = "0" ]; then
        echo -e "\n-- Disabling and removing AppArmor, please wait..."
        /etc/init.d/apparmor stop &> /dev/null
        update-rc.d -f apparmor remove &> /dev/null
        apt-get remove -y --purge apparmor* &> /dev/null
        disable_file /etc/init.d/apparmor &> /dev/null
        echo -e "AppArmor has been removed."
    fi
fi

#--- Adapt repositories and packages sources
echo -e "\n-- Updating repositories and packages sources"
sentora_mod 'repos'

#--- List all already installed packages (may help to debug)
echo -e "\n-- Listing of all packages installed:"
if [[ "$OS" = "CentOs" ]]; then
    rpm -qa | sort
elif [[ "$OS" = "Ubuntu" ]]; then
    dpkg --get-selections
fi

#--- Ensures that all packages are up to date
echo -e "\n-- Updating+upgrading system, it may take some time..."
if [[ "$OS" = "CentOs" ]]; then
    yum -y update
    yum -y upgrade
elif [[ "$OS" = "Ubuntu" ]]; then
    apt-get -yqq update
    apt-get -yqq upgrade
fi

#--- Install utility packages required by the installer and/or Sentora.
echo -e "\n-- Downloading and installing required tools..."
if [[ "$OS" = "CentOs" ]]; then
    $PACKAGE_INSTALLER sudo vim make zip unzip chkconfig bash-completion
    $PACKAGE_INSTALLER ld-linux.so.2 libbz2.so.1 libdb-4.7.so libgd.so.2 
    $PACKAGE_INSTALLER curl curl-devel perl-libwww-perl libxml2 libxml2-devel zip bzip2-devel gcc gcc-c++ at make
    $PACKAGE_INSTALLER redhat-lsb-core
elif [[ "$OS" = "Ubuntu" ]]; then
    $PACKAGE_INSTALLER sudo vim make zip unzip debconf-utils at build-essential bash-completion
fi

#--- Prepare hostname
old_hostname=$(cat /etc/hostname)
# In file hostname
echo "$PANEL_FQDN" > /etc/hostname

# In file hosts
sed -i "/127.0.1.1[\t ]*$old_hostname/d" /etc/hosts
sed -i "s|$old_hostname|$PANEL_FQDN|" /etc/hosts

# For current session
hostname "$PANEL_FQDN"

# In network file
if [[ "$OS" = "CentOs" && "$VER" = "6" ]]; then
    sed -i "s|^\(HOSTNAME=\).*\$|HOSTNAME=$PANEL_FQDN|" /etc/sysconfig/network
    /etc/init.d/network restart
fi

#--- Download Sentora archive from GitHub
echo -e "\n-- Downloading Sentora, Please wait, this may take several minutes, the installer will continue after this is complete!"
# Get latest sentora
wget -nv -O sentora_core.zip https://github.com/sentora/sentora-core/archive/$SENTORA_CORE_VERSION.zip
mkdir -p $PANEL_PATH
chown -R root:root $PANEL_PATH
unzip -oq sentora_core.zip -d $PANEL_PATH
mv "$PANEL_PATH/sentora-core-$SENTORA_CORE_VERSION" "$PANEL_PATH/panel"
rm sentora_core.zip
rm "$PANEL_PATH/panel/LICENSE.md" "$PANEL_PATH/panel/README.md" "$PANEL_PATH/panel/.gitignore"
rm -rf "$PANEL_PATH/_delete_me"

# Remove unusued build branch until it is also removed from github sentora-core master
rm -rf "$PANEL_PATH/panel/etc/build"

#--- Set-up Sentora directories and configure permissions
PANEL_CONF="$PANEL_PATH/configs"

mkdir -p $PANEL_CONF
mkdir -p $PANEL_PATH/docs
chmod -R 777 $PANEL_PATH

mkdir -p $PANEL_DATA/logs/proftpd
mkdir -p $PANEL_DATA/backups
chmod -R 777 $PANEL_DATA/

# Links for compatibility with zpanel access
ln -s $PANEL_PATH /etc/zpanel
ln -s $PANEL_DATA /var/zpanel

#--- Prepare Sentora executables
chmod +x $PANEL_PATH/panel/bin/zppy 
ln -s $PANEL_PATH/panel/bin/zppy /usr/bin/zppy

chmod +x $PANEL_PATH/panel/bin/setso
ln -s $PANEL_PATH/panel/bin/setso /usr/bin/setso

chmod +x $PANEL_PATH/panel/bin/setzadmin
ln -s $PANEL_PATH/panel/bin/setzadmin /usr/bin/setzadmin

#--- Install preconfig
wget -nv -O sentora_preconfig.zip https://github.com/sentora/sentora-installers/archive/$SENTORA_PRECONF_VERSION.zip
unzip -oq sentora_preconfig.zip
cp -rf sentora-installers-$SENTORA_PRECONF_VERSION/preconf/* $PANEL_CONF
rm sentora_preconfig*
rm -rf sentora-*

#--- Prepare zsudo
cc -o $PANEL_PATH/panel/bin/zsudo $PANEL_CONF/bin/zsudo.c
sudo chown root $PANEL_PATH/panel/bin/zsudo
chmod +s $PANEL_PATH/panel/bin/zsudo

#--- Some functions used many times below
# Random password generator function
passwordgen() {
    l=$1
    [ "$l" == "" ] && l=16
    tr -dc A-Za-z0-9 < /dev/urandom | head -c ${l} | xargs
}

# Add first parameter in hosts file as local IP domain
add_local_domain() {
    if ! grep -q "127.0.0.1 $1" /etc/hosts; then
        echo "127.0.0.1 $1" >> /etc/hosts;
    fi
}

#-----------------------------------------------------------
# Install all softwares and dependencies required by Sentora.

if [[ "$OS" = "Ubuntu" ]]; then
    # Disable the DPKG prompts before we run the software install to enable fully automated install.
    export DEBIAN_FRONTEND=noninteractive
fi

#--- MySQL
echo -e "\n-- Installing MySQL"
sentora_mod 'mysql'

#--- Postfix
echo -e "\n-- Installing Postfix"
sentora_mod 'postfix'

#--- Dovecot (includes Sieve)
echo -e "\n-- Installing Dovecot"
sentora_mod 'dovecot'

#--- Apache server
echo -e "\n-- Installing and configuring Apache"
sentora_mod 'apache'

#--- PHP
echo -e "\n-- Installing and configuring PHP"
sentora_mod 'php'

#--- ProFTPd
echo -e "\n-- Installing ProFTPD"
sentora_mod 'proftpd'

#--- BIND
echo -e "\n-- Installing and configuring Bind"
sentora_mod 'bind'

#--- CRON and ATD
echo -e "\n-- Installing and configuring cron tasks"
sentora_mod 'cron'

#--- phpMyAdmin
echo -e "\n-- Configuring phpMyAdmin"
sentora_mod 'phpmyadmin'

#--- Roundcube
echo -e "\n-- Configuring Roundcube"
sentora_mod 'roundcube'

#--- Webalizer
echo -e "\n-- Configuring Webalizer"
sentora_mod 'webalizer'

#--- Set some Sentora database entries using. setso and setzadmin (require PHP)
echo -e "\n-- Configuring Sentora"
zadminpassword=$(passwordgen);
setzadmin --set "$zadminpassword";
$PANEL_PATH/panel/bin/setso --set sentora_domain "$PANEL_FQDN"
$PANEL_PATH/panel/bin/setso --set server_ip "$PUBLIC_IP"

# if not release, set beta version in database
if [[ $(echo "$SENTORA_CORE_VERSION" | sed  's|.*-\(beta\).$|\1|') = "beta"  ]] ; then
    $PANEL_PATH/panel/bin/setso --set dbversion "$SENTORA_CORE_VERSION"
fi

# make the daemon to build vhosts file.
$PANEL_PATH/panel/bin/setso --set apache_changed "true"
php -q $PANEL_PATH/panel/bin/daemon.php


#--- Firewall ?


#--- Restart all services to capture output messages, if any
if [[ "$OS" = "CentOs" && "$VER" == "7" ]]; then
    # CentOs7 does not return anything except redirection to systemctl :-(
    service() {
       echo "Restarting $1"
       systemctl restart "$1.service"
    }
fi

service "$DB_SERVICE" restart
service "$HTTP_SERVICE" restart
service postfix restart
service dovecot restart
service "$CRON_SERVICE" restart
service "$BIND_SERVICE" restart
service proftpd restart
service atd restart

#--- Store the passwords for user reference
{
    echo "Server IP address : $PUBLIC_IP"
    echo "Panel URL         : http://$PANEL_FQDN"
    echo "zadmin Password   : $zadminpassword"
    echo ""
    echo "MySQL Root Password      : $mysqlpassword"
    echo "MySQL Postfix Password   : $postfixpassword"
    echo "MySQL ProFTPd Password   : $proftpdpassword"
    echo "MySQL Roundcube Password : $roundcubepassword"
} >> /root/passwords.txt

#--- Advise the admin that Sentora is now installed and accessible.
{
echo "########################################################"
echo " Congratulations Sentora has now been installed on your"
echo " server. Please review the log file left in /root/ for "
echo " any errors encountered during installation."
echo ""
echo " Login to Sentora at http://$PANEL_FQDN"
echo " Sentora Username  : zadmin"
echo " Sentora Password  : $zadminpassword"
echo ""
echo " MySQL Root Password      : $mysqlpassword"
echo " MySQL Postfix Password   : $postfixpassword"
echo " MySQL ProFTPd Password   : $proftpdpassword"
echo " MySQL Roundcube Password : $roundcubepassword"
echo "   (theses passwords are saved in /root/passwords.txt)"
echo "########################################################"
echo ""
} &>/dev/stdout

# Wait until the user have read before restarts the server...
if [[ "$INSTALL" != "auto" ]] ; then
    while true; do
        read -e -p "Restart your server now to complete the install (y/n)? " rsn
        case $rsn in
            [Yy]* ) break;;
            [Nn]* ) exit;
        esac
    done
    shutdown -r now
fi
