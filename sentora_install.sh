#!/usr/bin/env bash

# Official Sentora Automated Installation Script
# =============================================
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#    OS VERSION supported: CentOS 6.4+/7.x Minimal, Ubuntu 12.04/14.04 
#    32bit and 64bit

#SENTORA_GITHUB_VERSION="master"
SENTORA_GITHUB_VERSION="1.0.0"

SENTORA_PRECONF_VERSION="master"

PANEL_PATH="/etc/zpanel"
PANEL_DATA="/var/zpanel"


#--- Display the 'welcome' splash/user warning info..
echo -e "\n#################################################"
echo "#   Welcome to the Official Sentora Installer   #"
echo "#################################################"

echo -e "\nChecking that minimal requirements are ok"

# Ensure the OS is compatible with the launcher
BITS=$(uname -m | sed 's/x86_//;s/i[3-6]86/32/')
if [ -f /etc/lsb-release ]; then
    OS=$(grep DISTRIB_ID /etc/lsb-release | sed 's/^.*=//')
    VER=$(grep DISTRIB_RELEASE /etc/lsb-release | sed 's/^.*=//')
elif [ -f /etc/centos-release ]; then
    OS="CentOs"
    VERFULL=$(sed 's/^.*release //;s/ (Fin.*$//' /etc/centos-release)
    VER=${VERFULL:0:1} # return 6 or 7
else
    OS=$(uname -s)
    VER=$(uname -r)
fi
echo "Detected : $OS  $VER  $BITS"
if [[ "$OS" = "CentOs" && ("$VER" = "6" || "$VER" = "7" ) || 
      "$OS" = "Ubuntu" && ("$VER" = "12.04" || "$VER" = "14.04" ) ]] ; then 
    echo "Ok."
else
    echo "Sorry, this OS is not supported by Sentora." 
    exit 1;
fi

# Select modules that will be checked before start
if [[ "$OS" = "CentOs" ]] ; then
    PACKAGE_INSTALLER="yum -y -q install"
    PACKAGE_REMOVER="yum -y -q remove"

    if  [[ "$VER" = "7" ]]; then
        DB_SERVER="mariadb" &&  echo "DB server will be mariaDB"
    else 
        DB_SERVER="mysql" && echo "DB server will be mySQL"
    fi
    HTTP_SERVER="httpd"
elif [[ "$OS" = "Ubuntu" ]]; then
    PACKAGE_INSTALLER="apt-get -yqq install"
    PACKAGE_REMOVER="apt-get -yqq remove"
    
    DB_SERVER="mysql"
    HTTP_SERVER="apache"
fi
  
# Check if the user is 'root' before allowing installation to commence
if [ $UID -ne 0 ]; then
    echo "Install failed: you must be logged in as 'root' to install."
    echo "Use command 'sudo -i', then enter root password and then try again."
    exit 1
fi

# Check for some common control panels that we know will affect the installation/operating of Sentora.
if [ -e /usr/local/cpanel ] || [ -e /usr/local/directadmin ] || [ -e /usr/local/solusvm/www ] || [ -e /usr/local/home/admispconfig ] || [ -e /usr/local/lxlabs/kloxo ] ; then
    echo "It appears that a control panel is already installed on your server; This installer "
    echo "is designed to install and configure Sentora on a clean OS installation only!"
    echo -e "\nPlease re-install your OS before attempting to install using this script."
    exit 1;
fi

# Check for some common packages that we know will affect the installation/operating of Sentora.
# We expect a clean OS so no apache/mySQL/bind/postfix/php!
if [[ "$OS" = "CentOs" ]] ; then
    inst() {
       rpm -q "$1" 2> /dev/null
    }
elif [[ "$OS" = "Ubuntu" ]]; then
    inst() {
       dpkg -l "$1" 2> /dev/null | grep '^ii' &> /dev/null
    }
fi

if (inst $DB_SERVER) || (inst postfix) || (inst dovecot) || (inst $HTTP_SERVER) || (inst php) || (inst bind); then
    echo "It appears that apache/mysql/bind/postfix is already installed; This installer "
    echo "is designed to install and configure Sentora on a clean OS installation only!"
    echo -e "\nPlease re-install your OS before attempting to install using this script."
    exit 1;
fi

# ***************************************
# Prepare or query informations required to install

# Propose selection list for the time zone
echo "Preparing to select timezone, please wait a few seconds..."
$PACKAGE_INSTALLER tzdata wget
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

# Installer options
if [[ "$OS" = "CentOs" ]]; then
    $PACKAGE_INSTALLER bind-utils
elif [[ "$OS" = "Ubuntu" ]]; then
    $PACKAGE_INSTALLER dnsutils
fi    
echo "You will be asked for the FQDN that will be used to access Sentora on your server"
echo "- It MUST be a sub-domain of you main domain, it must NOT be your main domain only. Example: panel.yourdomain.com"
echo "- It MUST be already setup in your DNS nameserver (and propagated)."

fqdn=$(/bin/hostname)
publicip="$(wget -qO- http://api.sentora.org/ip.txt)"
while true; do
    while true; do
        read -e -p "FQDN for Sentora: " -i "$fqdn" fqdn
        sub=$(echo "$fqdn" | sed -n 's|\(.*\)\..*\..*|\1|p')
        if [[ "$sub" == "" ]]; then
            echo -e "\e[1;31m!!! WARNING !!!"
            echo -e "The FQDN must be a subdomain.\e[0m"
            read -e -p "Whatever, would you really want to continue (y:Yes n:change fqdn q:quit)? " yn
            case $yn in
                [Yy]* ) break;;
                [Nn]* ) continue;;
                [Qq]* ) exit;;
            esac
        fi
        
        dnsip=$(host "$fqdn"|grep address|cut -d" " -f4)
        if [[ "$dnsip" == "" ]]; then
            echo -e "\e[1;31m!!! WARNING !!!"
            echo -e "The subdomain $fqdn have no IP assigned in DNS\e[0m"
            echo "You must add a A record in the DNS manager for this subdomain"
            echo "  and then wait until propagation is done."
            echo "For more information, install documentation is at"
            echo " - http://docs.sentora.org/index.php?node=7 (Installing Sentora)"
            echo " - http://docs.sentora.org/index.php?node=51 (Installer questions)"
	          echo ""
            read -e -p "Whatever, would you really want to continue (y:Yes n:change fqdn q:quit)? " yn
            case $yn in
                [Yy]* ) break;;
                [Nn]* ) continue;;
                [Qq]* ) exit;;
            esac
	      else
	          break;
	      fi
	  done
    read -e -p "Enter the public (external) server IP: " -i "$publicip" publicip
    if [[ "$publicip" == "$dnsip" ]]; then
        break
    else	
        echo -e "\e[1;31m!!! WARNING !!!"
	      echo -e "The IP of your server is not the same than reported by the dns for domain $fqdn\e[0m"
        echo "Are you really SURE that you want to setup Sentora with these parameters?"
        read -e -p "(y):accept, (n):change fqdn or ip, (ctrl+c):quit installer? " yn
        case $yn in
            [Yy]* ) break;;
        esac
    fi
done
echo ""
while true; do
    read -e -p "Sentora is now ready to install, do you wish to continue (y/n)? " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;
    esac
done

# ***************************************
# Installation really starts here

#--- Set custom logging methods so we create a log file in the current working directory.
logfile=$$.log
touch $$.log
exec > >(tee $logfile)
exec 2>&1

echo -e "Installing Sentora $SENTORA_GITHUB_VERSION with fqdn $fqdn and ip $publicip"
echo -e "on server under: $OS  $VER  $BITS"
uname -a

#--- AppArmor must be disabled to avoid problems
if [[ "$OS" = "Ubuntu" ]]; then
    [ -f /etc/init.d/apparmor ]
    if [ $? = "0" ]; then
        echo -e "\n-- Disabling and removing AppArmor, please wait..."
        /etc/init.d/apparmor stop &> /dev/null
        update-rc.d -f apparmor remove &> /dev/null
        apt-get remove -y --purge apparmor* &> /dev/null
        mv /etc/init.d/apparmor /etc/init.d/apparmpr.removed &> /dev/null
        echo -e "AppArmor has been removed."
    fi
fi

#--- Adapt repositories and packages sources
echo -e "\n-- Updating repositories and packages sources"
if [[ "$OS" = "CentOs" ]]; then
    #EPEL Repo Install
    EPEL_BASE_URL="http://dl.fedoraproject.org/pub/epel/$VER/$(arch)";
    if  [[ "$VER" = "7" ]]; then
        EPEL_FILE=$(wget -q -O- "$EPEL_BASE_URL/e/" | grep -oP '(?<=href=")epel-release.*(?=">)')
        wget "$EPEL_BASE_URL/e/$EPEL_FILE"
    else 
        EPEL_FILE=$(wget -q -O- "$EPEL_BASE_URL/" | grep -oP '(?<=href=")epel-release.*(?=">)')
        wget "$EPEL_BASE_URL/$EPEL_FILE"
    fi
    $PACKAGE_INSTALLER -y install epel-release*.rpm
    rm "$EPEL_FILE"
    
    #To fix some problems of compatibility use of mirror centos.org to all users
    #Replace all mirrors by base repos to avoid any problems.
    sed -i 's|mirrorlist=http://mirrorlist.centos.org|#mirrorlist=http://mirrorlist.centos.org|' "/etc/yum.repos.d/CentOS-Base.repo"
    sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://mirror.centos.org|' "/etc/yum.repos.d/CentOS-Base.repo"

    #check if the machine and on openvz
    if [ -f "/etc/yum.repos.d/vz.repo" ]; then
        #vz.repo
        sed -i 's|mirrorlist=http://vzdownload.swsoft.com/download/mirrors/centos-6|baseurl=http://vzdownload.swsoft.com/ez/packages/centos/6/$basearch/os/|' "/etc/yum.repos.d/vz.repo"
        sed -i 's|mirrorlist=http://vzdownload.swsoft.com/download/mirrors/updates-released-ce6|baseurl=http://vzdownload.swsoft.com/ez/packages/centos/6/$basearch/updates/|' "/etc/yum.repos.d/vz.repo"
    fi

    #disable deposits that could result in installation errors
    disablerepo() {
        if [ -f "/etc/yum.repos.d/$1.repo" ]; then
            sed -i 's/enabled=1/enabled=0/g' "/etc/yum.repos.d/$1.repo"
        fi
    }
    disablerepo "elrepo"
    disablerepo "epel-testing"
    disablerepo "remi"
    disablerepo "rpmforge"
    disablerepo "rpmfusion-free-updates"
    disablerepo "rpmfusion-free-updates-testing"

    # We need to disable SELinux...
    sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
    setenforce 0

    # Stop conflicting services and iptables to ensure all services will work
    service sendmail stop
    chkconfig sendmail off

    # disable firewall
    if  [[ "$VER" = "7" ]]; then
        FIREWALL_SERVICE="firewalld"
    else 
        FIREWALL_SERVICE="iptables"
    fi
    service "$FIREWALL_SERVICE" save
    service "$FIREWALL_SERVICE" stop
    chkconfig "$FIREWALL_SERVICE" off

    # Removal of conflicting packages prior to Sentora installation.
    if (inst bind-chroot) ; then 
        $PACKAGE_REMOVER bind-chroot
    fi
    if (inst qpid-cpp-client) ; then
        $PACKAGE_REMOVER qpid-cpp-client
    fi

elif [[ "$OS" = "Ubuntu" ]]; then 
    # Update the enabled Aptitude repositories
    echo -ne "\nUpdating Aptitude Repos: " >/dev/tty

    mkdir -p "/etc/apt/sources.list.d.save"
    cp -R "/etc/apt/sources.list.d/*" "/etc/apt/sources.list.d.save" &> /dev/null
    rm -rf "/etc/apt/sources.list/*"
    cp "/etc/apt/sources.list" "/etc/apt/sources.list.save"

    if [ "$VER" = "12.04" ]; then
        cat > /etc/apt/sources.list <<EOF
#Depots main restricted
deb http://archive.ubuntu.com/ubuntu/ $(lsb_release -sc) main restricted
deb http://security.ubuntu.com/ubuntu $(lsb_release -sc)-security main restricted
deb http://archive.ubuntu.com/ubuntu/ $(lsb_release -sc)-updates main restricted
 
deb-src http://archive.ubuntu.com/ubuntu/ $(lsb_release -sc) main restricted
deb-src http://archive.ubuntu.com/ubuntu/ $(lsb_release -sc)-updates main restricted
deb-src http://security.ubuntu.com/ubuntu $(lsb_release -sc)-security main restricted

#Depots Universe Multiverse 
deb http://archive.ubuntu.com/ubuntu/ $(lsb_release -sc) universe multiverse
deb http://security.ubuntu.com/ubuntu $(lsb_release -sc)-security universe multiverse
deb http://archive.ubuntu.com/ubuntu/ $(lsb_release -sc)-updates universe multiverse

deb-src http://archive.ubuntu.com/ubuntu/ $(lsb_release -sc) universe multiverse
deb-src http://security.ubuntu.com/ubuntu $(lsb_release -sc)-security universe multiverse
deb-src http://archive.ubuntu.com/ubuntu/ $(lsb_release -sc)-updates universe multiverse
EOF
    elif [ "$VER" = "14.04" ]; then
        cat > /etc/apt/sources.list <<EOF
#Depots main restricted
deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc)-security main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc)-updates main restricted universe multiverse
EOF
    fi
fi

#--- For debug (log file required from user)
echo -e "\n-- Listing of all packages installed:"
if [[ "$OS" = "CentOs" ]]; then
    rpm -qa | sort
elif [[ "$OS" = "Ubuntu" ]]; then
    dpkg --get-selections
fi

#--- Ensure all packages are updated
echo -e "\n-- Updating+upgrading system, it may take some time..."
if [[ "$OS" = "CentOs" ]]; then
    yum -y update
    yum -y upgrade
elif [[ "$OS" = "Ubuntu" ]]; then
    apt-get -yqq update
    apt-get -yqq upgrade
fi


#--- Install some standard utility packages required by the installer and/or Sentora.
echo -e "\n-- Downloading and installing required tools..."
if [[ "$OS" = "CentOs" ]]; then
    $PACKAGE_INSTALLER sudo vim make zip unzip git chkconfig bash-completion
    $PACKAGE_INSTALLER ld-linux.so.2 libbz2.so.1 libdb-4.7.so libgd.so.2 
    $PACKAGE_INSTALLER curl curl-devel perl-libwww-perl libxml2 libxml2-devel zip bzip2-devel gcc gcc-c++ at make
elif [[ "$OS" = "Ubuntu" ]]; then
    $PACKAGE_INSTALLER sudo vim make zip unzip git debconf-utils at build-essential bash-completion
fi

#--- Clone Sentora from GitHub
echo -e "\n-- Downloading Sentora, Please wait, this may take several minutes, the installer will continue after this is complete!"
# Get latest sentora
wget -nv -O sentora_installer.zip https://github.com/sentora/sentora-core/archive/$SENTORA_GITHUB_VERSION.zip
mkdir -p $PANEL_PATH
chown -R root:root $PANEL_PATH
unzip -oq sentora_installer.zip -d $PANEL_PATH
mv "$PANEL_PATH/sentora-core-$SENTORA_GITHUB_VERSION" "$PANEL_PATH/panel"
rm sentora_installer.zip
rm "$PANEL_PATH/panel/LICENSE.md" "$PANEL_PATH/panel/README.md" "$PANEL_PATH/panel/.gitignore"
rm -rf "$PANEL_PATH/_delete_me"

# Set-up Sentora directories and configure permissions
mkdir -p $PANEL_PATH/configs
mkdir -p $PANEL_PATH/docs
chmod -R 777 $PANEL_PATH

mkdir -p $PANEL_DATA/logs/proftpd
mkdir -p $PANEL_DATA/backups
chmod -R 777 $PANEL_DATA/

ln -s $PANEL_PATH/panel/bin/zppy /usr/bin/zppy
ln -s $PANEL_PATH/panel/bin/setso /usr/bin/setso
ln -s $PANEL_PATH/panel/bin/setzadmin /usr/bin/setzadmin
chmod +x $PANEL_PATH/panel/bin/zppy $PANEL_PATH/panel/bin/setso

# install preconfig 
wget -nv -O sentora_preconfig.zip https://github.com/5050/sentora-installers/archive/$SENTORA_PRECONF_VERSION.zip
unzip -oq sentora_preconfig.zip
cp -rf sentora-installers-$SENTORA_PRECONF_VERSION/preconf/* $PANEL_PATH/configs
rm sentora_preconfig*
rm -rf sentora-*

# prepare zsudo
cc -o $PANEL_PATH/panel/bin/zsudo $PANEL_PATH/configs/bin/zsudo.c
sudo chown root $PANEL_PATH/panel/bin/zsudo
chmod +s $PANEL_PATH/panel/bin/zsudo

# Random password generator function
passwordgen() {
    l=$1
    [ "$l" == "" ] && l=16
    tr -dc A-Za-z0-9 < /dev/urandom | head -c ${l} | xargs
}

#-----------------------------------------------------------
# Install all softwares and dependencies required by Sentora.

if [[ "$OS" = "Ubuntu" ]]; then
    # Disable the DPKG prompts before we run the software install to enable fully automated install.
    export DEBIAN_FRONTEND=noninteractive
fi


#--- MySQL
echo -e "\n-- Installing MySQL"
mysqlpassword=$(passwordgen);
if [[ "$OS" = "CentOs" ]]; then
    $PACKAGE_INSTALLER "$DB_SERVER" "$DB_SERVER-devel" "$DB_SERVER-server" 
    MY_CNF_PATH="/etc/my.cnf"
    if  [[ "$VER" = "7" ]]; then
        DB_SERVICE="mariadb"
    else 
        DB_SERVICE="mysqld"
    fi
elif [[ "$OS" = "Ubuntu" ]]; then
    $PACKAGE_INSTALLER bsdutils
    $PACKAGE_INSTALLER "$DB_SERVER-server" libsasl2-modules-sql libsasl2-modules
    if [ "$VER" = "12.04" ]; then
        $PACKAGE_INSTALLER db4.7-util
    fi
    MY_CNF_PATH="/etc/mysql/my.cnf"
    DB_SERVICE="mysql"
fi
service $DB_SERVICE start

# setup mysql root password
mysqladmin -u root password "$mysqlpassword"

# check that root password works. 
# removed : mysql is now always just installed
#until mysql -u root -p"$mysqlpassword" -e ";" > /dev/null 2>&1 ; do
#    read -s -p "enter your root $DB_SERVER password : " mysqlpassword
#done

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
mysql -u root -p"$mysqlpassword" < $PANEL_PATH/configs/sentora-install/sql/sentora_core.sql


#--- Postfix
echo -e "\n-- Installing Postfix"
postfixpassword=$(passwordgen);
if [[ "$OS" = "CentOs" ]]; then
    $PACKAGE_INSTALLER postfix postfix-perl-scripts
    USR_LIB_PATH="/usr/libexec"
elif [[ "$OS" = "Ubuntu" ]]; then
    $PACKAGE_INSTALLER postfix postfix-mysql
    USR_LIB_PATH="/usr/lib"
fi
mysql -u root -p"$mysqlpassword" < $PANEL_PATH/configs/sentora-install/sql/sentora_postfix.sql
mysql -u root -p"$mysqlpassword" -e "UPDATE mysql.user SET Password=PASSWORD('$postfixpassword') WHERE User='postfix' AND Host='localhost';";

mkdir $PANEL_DATA/vmail
useradd -r -g mail -d $PANEL_DATA/vmail -s /sbin/nologin -c "Virtual maildir" vmail
chown -R vmail:mail $PANEL_DATA/vmail
chmod -R 770 $PANEL_DATA/vmail

mkdir -p /var/spool/vacation
useradd -r -d /var/spool/vacation -s /sbin/nologin -c "Virtual vacation" vacation
chown -R vacation:vacation /var/spool/vacation
chmod -R 770 /var/spool/vacation

mkdir -p /etc/postfix/transport
postmap /etc/postfix/transport
if ! grep -q "127.0.0.1 autoreply.$fqdn" /etc/hosts; then
    echo "127.0.0.1 autoreply.$fqdn" >> /etc/hosts; 
fi

rm -rf /etc/postfix/main.cf /etc/postfix/master.cf
ln -s $PANEL_PATH/configs/postfix/master.cf /etc/postfix/master.cf
ln -s $PANEL_PATH/configs/postfix/main.cf /etc/postfix/main.cf
ln -s $PANEL_PATH/configs/postfix/vacation.pl /var/spool/vacation/vacation.pl

sed -i "s|!POSTFIX_PASSWORD!|$postfixpassword|" $PANEL_PATH/configs/postfix/*.cf
sed -i "s|!POSTFIX_PASSWORD!|$postfixpassword|" $PANEL_PATH/configs/postfix/vacation.conf
sed -i "s|!PANEL_FQDN!|$fqdn|" $PANEL_PATH/configs/postfix/main.cf

sed -i "s|!USR_LIB!|$USR_LIB_PATH|" $PANEL_PATH/configs/postfix/master.cf
sed -i "s|!USR_LIB!|$USR_LIB_PATH|" $PANEL_PATH/configs/postfix/main.cf

VMAIL_UID=$(id -u vmail)
MAIL_GID=$(sed -nr "s/^mail:x:([0-9]+):.*/\1/p" /etc/group)
sed -i "s|!POS_UID!|$VMAIL_UID|" $PANEL_PATH/configs/postfix/main.cf
sed -i "s|!POS_GID!|$MAIL_GID|" $PANEL_PATH/configs/postfix/main.cf

# remove unusued directives that issue warnings
sed -i '/virtual_mailbox_limit_maps/d' /etc/postfix/main.cf
sed -i '/smtpd_bind_address/d' /etc/postfix/master.cf


#--- Dovecot (includes Sieve)
echo -e "\n-- Installing Dovecot"
if [[ "$OS" = "CentOs" ]]; then
    $PACKAGE_INSTALLER dovecot dovecot-mysql dovecot-pigeonhole 
    sed -i "s|#first_valid_uid = ?|first_valid_uid = $VMAIL_UID\n#last_valid_uid = $VMAIL_UID\n\nfirst_valid_gid = $MAIL_GID\n#last_valid_gid = $MAIL_GID|" /etc/dovecot/dovecot.conf
elif [[ "$OS" = "Ubuntu" ]]; then
    $PACKAGE_INSTALLER dovecot-mysql dovecot-imapd dovecot-pop3d dovecot-common dovecot-managesieved dovecot-lmtpd 
    sed -i "s|#first_valid_uid = ?|first_valid_uid = $VMAIL_UID\nlast_valid_uid = $VMAIL_UID\n\nfirst_valid_gid = $MAIL_GID\nlast_valid_gid = $MAIL_GID|" /etc/dovecot/dovecot.conf
fi

mkdir -p $PANEL_DATA/sieve
chown -R vmail:mail $PANEL_DATA/sieve
mkdir -p /var/lib/dovecot/sieve/
touch /var/lib/dovecot/sieve/default.sieve
ln -s $PANEL_PATH/configs/dovecot2/globalfilter.sieve $PANEL_DATA/sieve/globalfilter.sieve
rm -rf /etc/dovecot/dovecot.conf
ln -s $PANEL_PATH/configs/dovecot2/dovecot.conf /etc/dovecot/dovecot.conf
sed -i "s|!POSTMASTER_EMAIL!|postmaster@$fqdn|" /etc/dovecot/dovecot.conf
sed -i "s|!POSTFIX_PASSWORD!|$postfixpassword|" $PANEL_PATH/configs/dovecot2/dovecot-dict-quota.conf
sed -i "s|!POSTFIX_PASSWORD!|$postfixpassword|" $PANEL_PATH/configs/dovecot2/dovecot-mysql.conf
sed -i "s|!DOV_UID!|$VMAIL_UID|" $PANEL_PATH/configs/dovecot2/dovecot-mysql.conf
sed -i "s|!DOV_GID!|$MAIL_GID|" $PANEL_PATH/configs/dovecot2/dovecot-mysql.conf

touch /var/log/dovecot.log /var/log/dovecot-info.log /var/log/dovecot-debug.log
chown vmail:mail /var/log/dovecot*
chmod 660 /var/log/dovecot*


#--- Apache server
echo -e "\n-- Installing and configuring Apache"
if [[ "$OS" = "CentOs" ]]; then
    $PACKAGE_INSTALLER $HTTP_SERVER $HTTP_SERVER-devel 
    HTTP_CONF_PATH="/etc/httpd/conf/httpd.conf"
    HTTP_VARS_PATH="/etc/sysconfig/httpd"
    HTTP_SERVICE="httpd"
    HTTP_USER="apache"
    HTTP_GROUP="apache"
    if [[ "$VER" = "6" ]]; then
        sed "s|#NameVirtualHost|NameVirtualHost|" "$HTTP_CONF_PATH"
    fi
    
elif [[ "$OS" = "Ubuntu" ]]; then
    $PACKAGE_INSTALLER apache2 libapache2-mod-bw
    HTTP_CONF_PATH="/etc/apache2/apache2.conf"
    HTTP_VARS_PATH="/etc/apache2/envvars"
    HTTP_SERVICE="apache2"
    HTTP_USER="www-data"
    HTTP_GROUP="www-data"
    
    a2enmod rewrite
fi

if ! grep -q "Include $PANEL_PATH/configs/apache/httpd.conf" "$HTTP_CONF_PATH"; then
    echo "Include $PANEL_PATH/configs/apache/httpd.conf" >> "$HTTP_CONF_PATH";
fi
if ! grep -q "127.0.0.1 $fqdn" /etc/hosts; then
    echo "127.0.0.1 $fqdn" >> /etc/hosts;
fi
serverhost=$(hostname)
if ! grep -q "127.0.0.1 $serverhost" /etc/hosts; then
    echo "127.0.0.1 $serverhost" >> /etc/hosts;
fi
if ! grep -q "apache ALL=NOPASSWD: $PANEL_PATH/panel/bin/zsudo" /etc/sudoers; then
    echo "apache ALL=NOPASSWD: $PANEL_PATH/panel/bin/zsudo" >> /etc/sudoers;
fi

#Create roots directory for HHTP docs
mkdir -p $PANEL_DATA/hostdata/zadmin/public_html
chown -R $HTTP_USER:$HTTP_GROUP $PANEL_DATA/hostdata/
chmod -R 770 $PANEL_DATA/hostdata/

if [[ "$OS" = "CentOs" ]]; then
    sed -i "s|DocumentRoot \"/var/www/html\"|DocumentRoot $PANEL_PATH/panel|" "$HTTP_CONF_PATH"
elif [[ "$OS" = "Ubuntu" ]]; then
    # disable completely sites-enabled/000-default.conf
    if [[ "$VER" = "12.04" ]]; then 
        sed -i "s|Include sites-enabled|#&|" "$HTTP_CONF_PATH"
    else
        sed -i "s|IncludeOptional sites-enabled|#&|" "$HTTP_CONF_PATH"
    fi
fi

if [[ "$OS" = "CentOs" ]]; then
    mysql -u root -p"$mysqlpassword" -e "UPDATE zpanel_core.x_settings SET so_value_tx='httpd24' WHERE so_name_vc='httpd_exe'"
    mysql -u root -p"$mysqlpassword" -e "UPDATE zpanel_core.x_settings SET so_value_tx='httpd24-httpd' WHERE so_name_vc='apache_sn'"
elif [[ "$OS" = "Ubuntu" ]]; then
    mysql -u root -p"$mysqlpassword" -e "UPDATE zpanel_core.x_settings SET so_value_tx='apache2' WHERE so_name_vc='httpd_exe'"
    mysql -u root -p"$mysqlpassword" -e "UPDATE zpanel_core.x_settings SET so_value_tx='apache2' WHERE so_name_vc='apache_sn'"
fi

#Set keepalive on (default is off)
sed -i "s|KeepAlive Off|KeepAlive On|" $HTTP_CONF_PATH

# Permissions fix for Apache and ProFTPD (to enable them to play nicely together!)
if ! grep -q "umask 002" "$HTTP_VARS_PATH"; then
    echo "umask 002" >> "$HTTP_VARS_PATH";
fi

# small touch until core file is updated
sed -i 's| \$customPort = array|$customPorts = array|' /etc/zpanel/panel/modules/apache_admin/hooks/OnDaemonRun.hook.php

#adjustement for apache 2.4
# Order allow,deny / Allow from all  ->  Require all granted
# Order deny,allow / Deny from all   ->  Require all denied
if [[ ("$OS" = "CentOs" && "$VER" = "7") || 
      ("$OS" = "Ubuntu" && "$VER" = "14.04") ]] ; then 
    sed -i 's|Order deny,allow|Require all denied|I'  $PANEL_PATH/configs/apache/httpd.conf
    sed -i '/Deny from all/d' $PANEL_PATH/configs/apache/httpd.conf

    sed -i 's|Order allow,deny|Require all granted|I' $PANEL_PATH/configs/apache/httpd-vhosts.conf
    sed -i '/Allow from all/d' $PANEL_PATH/configs/apache/httpd-vhosts.conf

    sed -i 's|Order allow,deny|Require all granted|I'  $PANEL_PATH/panel/modules/apache_admin/hooks/OnDaemonRun.hook.php
    sed -i '/Allow from all/d' $PANEL_PATH/panel/modules/apache_admin/hooks/OnDaemonRun.hook.php
fi

# - remove NameVirtualHost that is now without effect and generate warning
sed -i '/    \$line \.= \"NameVirtualHost/ {N;N;N;N;d}' /etc/zpanel/panel/modules/apache_admin/hooks/OnDaemonRun.hook.php
# - Options must have ALL (or none) +/- prefix, disable listing directories
sed -i 's| FollowSymLinks [-]Indexes| +FollowSymLinks -Indexes|' /etc/zpanel/panel/modules/apache_admin/hooks/OnDaemonRun.hook.php


#--- PHP
echo -e "\n-- Installing and configuring PHP"
if [[ "$OS" = "CentOs" ]]; then
    $PACKAGE_INSTALLER php php-devel php-gd php-mbstring php-intl php-mysql php-xml php-xmlrpc
    $PACKAGE_INSTALLER php-mcrypt php-imap  #Epel packages
    PHP_INI_PATH="/etc/php.ini"
    PHP_EXT_PATH="/etc/php.d"
elif [[ "$OS" = "Ubuntu" ]]; then
    $PACKAGE_INSTALLER libapache2-mod-php5 php5-common php5-cli php5-mysql php5-gd php5-mcrypt php5-curl php-pear php5-imap php5-xmlrpc php5-xsl
    if [ "$VER" = "12.04" ]; then
        $PACKAGE_INSTALLER php5-suhosin
    fi
    PHP_INI_PATH="/etc/php5/apache2/php.ini"
fi
# php upload dir
mkdir -p $PANEL_DATA/temp
chmod 1777 $PANEL_DATA/temp/
chown -R $HTTP_USER:$HTTP_GROUP $PANEL_DATA/temp/

# php session save directory
mkdir "$PANEL_DATA/sessions"
chown $HTTP_USER:$HTTP_GROUP "$PANEL_DATA/sessions"
chmod 733 "$PANEL_DATA/sessions"
chmod +t "$PANEL_DATA/sessions"

sed -i "s|;date.timezone =|date.timezone = $tz|" $PHP_INI_PATH
sed -i "s|;upload_tmp_dir =|upload_tmp_dir = $PANEL_DATA/temp/|" $PHP_INI_PATH

# init sessions save directory
sed -i "s|;session.save_path = \"/var/lib/php5\"|session.save_path = \"$PANEL_DATA/sessions\"|" $PHP_INI_PATH

# Disable php signature in headers to hide it from hackers
sed -i "s|expose_php = On|expose_php = Off|" $PHP_INI_PATH

# Build suhosin for PHP 5.x which is required by Sentora. 
if [[ "$OS" = "CentOs" || ( "$OS" = "Ubuntu" && "$VER" = "14.04") ]] ; then
    echo -e "\n# Building suhosin for php5.4"
    if [[ "$OS" = "Ubuntu" ]]; then
        $PACKAGE_INSTALLER php5-dev
    fi
    git clone https://github.com/stefanesser/suhosin
    cd suhosin
    phpize
    ./configure
    make
    make install
    cd ..
    rm -rf suhosin
    if [[ "$OS" = "CentOs" ]]; then 
        echo 'extension=suhosin.so' > $PHP_EXT_PATH/suhosin.ini
    elif [[ "$OS" = "Ubuntu" ]]; then
        sed -i 'N;/default extension directory./a\extension=suhosin.so' $PHP_EXT_PATH/php.ini
    fi	
fi


#--- ProFTPD
echo -e "\n-- Installing ProFTPD"
if [[ "$OS" = "CentOs" ]]; then
    $PACKAGE_INSTALLER proftpd proftpd-mysql 
    FTP_CONF_PATH='/etc/proftpd.conf'
    if [[ "VER" = "7" ]] ; then
        sed "s|nogroup|nobody|" $PANEL_PATH/configs/proftpd/proftpd-mysql.conf
    fi
elif [[ "$OS" = "Ubuntu" ]]; then
    $PACKAGE_INSTALLER proftpd-mod-mysql
    FTP_CONF_PATH='/etc/proftpd/proftpd.conf'
fi

#create and init proftpd database
mysql -u root -p"$mysqlpassword" < $PANEL_PATH/configs/sentora-install/sql/sentora_proftpd.sql

#create and configure mysql password for proftpd
proftpdpassword=$(passwordgen);
sed -i "s|!SQL_PASSWORD!|$proftpdpassword|" $PANEL_PATH/configs/proftpd/proftpd-mysql.conf
mysql -u root -p"$mysqlpassword" -e "UPDATE mysql.user SET Password=PASSWORD('$proftpdpassword') WHERE User='proftpd' AND Host='localhost'";

#assign httpd user and group to all users that will be created
HTTP_UID=$(id -u "$HTTP_USER")
HTTP_GID=$(sed -nr "s/^$HTTP_GROUP:x:([0-9]+):.*/\1/p" /etc/group)
mysql -u root -p"$mysqlpassword" -e "ALTER TABLE zpanel_proftpd.ftpuser ALTER COLUMN uid SET DEFAULT $HTTP_UID"
mysql -u root -p"$mysqlpassword" -e "ALTER TABLE zpanel_proftpd.ftpuser ALTER COLUMN gid SET DEFAULT $HTTP_GID"
sed -i "s|!SQL_MIN_ID!|$HTTP_UID|" $PANEL_PATH/configs/proftpd/proftpd-mysql.conf

#setup proftpd base file to call zpanel config
rm -f "$FTP_CONF_PATH"
touch "$FTP_CONF_PATH"
if ! grep -q "include $PANEL_PATH/configs/proftpd/proftpd-mysql.conf" "$FTP_CONF_PATH"; then
    echo "include $PANEL_PATH/configs/proftpd/proftpd-mysql.conf" >> "$FTP_CONF_PATH"; 
fi
chmod -R 644 $PANEL_DATA/logs/proftpd


#--- BIND
echo -e "\n-- Installing and configuring Bind"
if [[ "$OS" = "CentOs" ]]; then
    $PACKAGE_INSTALLER bind bind-utils bind-libs
    BIND_PATH="/etc/named/"
    BIND_FILES="/etc"
    BIND_SERVICE="named"
    BIND_USER="named"
elif [[ "$OS" = "Ubuntu" ]]; then
    $PACKAGE_INSTALLER bind9 bind9utils
    BIND_PATH="/etc/bind/"
    BIND_FILES="/etc/bind"
    BIND_SERVICE="bind9"
    BIND_USER="bind"
    mysql -u root -p"$mysqlpassword" -e "UPDATE zpanel_core.x_settings SET so_value_tx='' WHERE so_name_vc='bind_log'"
fi
mysql -u root -p"$mysqlpassword" -e "UPDATE zpanel_core.x_settings SET so_value_tx='$BIND_PATH' WHERE so_name_vc='bind_dir'"
mysql -u root -p"$mysqlpassword" -e "UPDATE zpanel_core.x_settings SET so_value_tx='$BIND_SERVICE' WHERE so_name_vc='bind_service'"
chmod -R 777 $PANEL_PATH/configs/bind/zones/

# setup logging directory
mkdir $PANEL_DATA/logs/bind
touch $PANEL_DATA/logs/bind/bind.log $PANEL_DATA/logs/bind/debug.log
chown $BIND_USER $PANEL_DATA/logs/bind/bind.log $PANEL_DATA/logs/bind/debug.log
chmod 660 $PANEL_DATA/logs/bind/bind.log $PANEL_DATA/logs/bind/debug.log

if [[ "$OS" = "CentOs" ]]; then
    chmod 751 /var/named
    chmod 771 /var/named/data
    sed -i 's|bind/zones.rfc1918|named.rfc1912.zones|' $PANEL_PATH/configs/bind/named.conf
elif [[ "$OS" = "Ubuntu" ]]; then
    mkdir -p /var/named/dynamic
    touch /var/named/dynamic/managed-keys.bind
    chown -R bind:bind /var/named/
    chmod -R 777 $PANEL_PATH/configs/bind/etc

    chown root:root $BIND_FILES/rndc.key
    chmod 755 $BIND_FILES/rndc.key
fi
#some link to enable call from path
ln -s /usr/sbin/named-checkconf /usr/bin/named-checkconf
ln -s /usr/sbin/named-checkzone /usr/bin/named-checkzone
ln -s /usr/sbin/named-compilezone /usr/bin/named-compilezone

# build key and conf files
rm -rf $BIND_FILES/named.conf $BIND_FILES/rndc.conf $BIND_FILES/rndc.key
rndc-confgen -a -r /dev/urandom
cat $BIND_FILES/rndc.key $PANEL_PATH/configs/bind/named.conf > $BIND_FILES/named.conf
cat $BIND_FILES/rndc.key $PANEL_PATH/configs/bind/rndc.conf > $BIND_FILES/rndc.conf
rm -f $BIND_FILES/rndc.key

#--- CRON
echo -e "\n-- Installing and configuring cron tasks"
if [[ "$OS" = "CentOs" ]]; then
    #cronie & crontabs may be missing
    $PACKAGE_INSTALLER crontabs
    CRON_FILE="/var/spool/cron/apache"
    CRON_USER="apache"
    CRON_SERVICE="crond"
elif [[ "$OS" = "Ubuntu" ]]; then
    CRON_FILE="/var/spool/cron/crontabs/www-data"
    CRON_USER="www-data"
    CRON_SERVICE="cron"
fi
mysql -u root -p"$mysqlpassword" -e "UPDATE zpanel_core.x_settings SET so_value_tx='$CRON_FILE' WHERE so_name_vc='cron_file'"
mysql -u root -p"$mysqlpassword" -e "UPDATE zpanel_core.x_settings SET so_value_tx='$CRON_FILE' WHERE so_name_vc='cron_reload_path'"
mysql -u root -p"$mysqlpassword" -e "UPDATE zpanel_core.x_settings SET so_value_tx='$CRON_USER' WHERE so_name_vc='cron_reload_user'"

if [[ "$OS" = "CentOs" ]]; then
    PANEL_DAEMON_PATH="$PANEL_PATH/panel/bin/daemon.php"
    crontab -l -u $HTTP_USER > mycron
    echo "*/5 * * * * nice -2 php -q $PANEL_DAEMON_PATH >> $PANEL_PATH/daemon_last_run.log 2>&1" >> mycron
    crontab -u $HTTP_USER mycron
    rm -f mycron
    
elif [[ "$OS" = "Ubuntu" ]]; then
    mkdir -p /var/spool/cron/crontabs/
    mkdir -p /etc/cron.d/
    touch /var/spool/cron/crontabs/www-data
    touch /etc/cron.d/www-data
    crontab -u www-data /var/spool/cron/crontabs/www-data
    cp $PANEL_PATH/configs/cron/zdaemon /etc/cron.d/zdaemon
    chmod -R 644 /var/spool/cron/crontabs/
    chmod 744 /var/spool/cron/crontabs
    chmod -R 644 /etc/cron.d/
    chown -R www-data:www-data /var/spool/cron/crontabs/
fi


#--- phpMyAdmin
echo -e "\n-- Configuring phpMyAdmin"
phpmyadminsecret=$(passwordgen);
chmod 644 $PANEL_PATH/configs/phpmyadmin/config.inc.php
sed -i "s|\$cfg\['blowfish_secret'\] \= 'SENTORA';|\$cfg\['blowfish_secret'\] \= '$phpmyadminsecret';|" $PANEL_PATH/configs/phpmyadmin/config.inc.php
ln -s $PANEL_PATH/configs/phpmyadmin/config.inc.php $PANEL_PATH/panel/etc/apps/phpmyadmin/config.inc.php
# Remove phpMyAdmin's setup folder in case it was left behind
rm -rf $PANEL_PATH/panel/etc/apps/phpmyadmin/setup


#--- Roundcube specific installation tasks...
echo -e "\n-- Configuring Roundcube"
roundcube_des_key=$(passwordgen 24);
mysql -u root -p"$mysqlpassword" < $PANEL_PATH/configs/sentora-install/sql/sentora_roundcube.sql
sed -i "s|YOUR_MYSQL_ROOT_PASSWORD|$mysqlpassword|" $PANEL_PATH/configs/roundcube/db.inc.php
sed -i "s|#||" $PANEL_PATH/configs/roundcube/db.inc.php
sed -i "s|rcmail-!24ByteDESkey\*Str|$roundcube_des_key|" $PANEL_PATH/configs/roundcube/main.inc.php
rm -rf $PANEL_PATH/panel/etc/apps/webmail/config/main.inc.php
ln -s $PANEL_PATH/configs/roundcube/main.inc.php $PANEL_PATH/panel/etc/apps/webmail/config/main.inc.php
ln -s $PANEL_PATH/configs/roundcube/config.inc.php $PANEL_PATH/panel/etc/apps/webmail/plugins/managesieve/config.inc.php
ln -s $PANEL_PATH/configs/roundcube/db.inc.php $PANEL_PATH/panel/etc/apps/webmail/config/db.inc.php

#--- Webalizer specific installation tasks...
echo -e "\n-- Configuring Webalizer"
$PACKAGE_INSTALLER webalizer
if [[ "$OS" = "CentOs" ]]; then
    rm -rf /etc/webalizer.conf
elif [[ "$OS" = "Ubuntu" ]]; then
    rm -rf /etc/webalizer/webalizer.conf
fi


#--- Set some Sentora database entries using. setso and setzadmin
echo -e "\n-- Configuring Sentora"
zadminpassword=$(passwordgen);
setzadmin --set "$zadminpassword";
$PANEL_PATH/panel/bin/setso --set zpanel_domain "$fqdn"
$PANEL_PATH/panel/bin/setso --set server_ip "$publicip"

# make the daemon to build vhosts file.
$PANEL_PATH/panel/bin/setso --set apache_changed "true"
php -q $PANEL_PATH/panel/bin/daemon.php


#--- firewall


# Enable system services and start/restart them as required.
echo -e "\n-- Starting/restarting services"
if [[ "$OS" = "CentOs" ]]; then
    chkconfig $HTTP_SERVER on
    chkconfig postfix on
    chkconfig dovecot on
    chkconfig crond on
    chkconfig $DB_SERVICE on
    chkconfig named on
    chkconfig proftpd on
    service $HTTP_SERVER start
fi    

# restart all services to capture output messages
service "$DB_SERVICE" restart
service "$HTTP_SERVICE" restart
service postfix restart
service dovecot restart
service "$CRON_SERVICE" restart
service "$BIND_SERVICE" restart
service proftpd restart
service atd restart

# Store the passwords for user reference
{
    echo "zadmin Password        : $zadminpassword"
    echo "MySQL Root Password    : $mysqlpassword"
    echo "MySQL Postfix Password : $postfixpassword"
    echo "MySQL ProFTPd Password : $proftpdpassword"
    echo "IP Address: $publicip"
    echo "Panel Domain: $fqdn"
} >> /root/passwords.txt

# Advise the user that Sentora is now installed and accessible.
echo "#########################################################" &>/dev/tty
echo " Congratulations Sentora has now been installed on your"   &>/dev/tty
echo " server. Please review the log file left in /root/ for "   &>/dev/tty
echo " any errors encountered during installation."              &>/dev/tty
echo ""                                                          &>/dev/tty
echo " Sentora Username       : zadmin"                          &>/dev/tty
echo " Sentora Password       : $zadminpassword"                 &>/dev/tty
echo ""                                                          &>/dev/tty
echo " MySQL Root Password    : $mysqlpassword"                  &>/dev/tty
echo " MySQL Postfix Password : $postfixpassword"                &>/dev/tty
echo " MySQL ProFTPd Password : $proftpdpassword"                &>/dev/tty
echo "   (theses passwords are saved in /root/passwords.txt)"    &>/dev/tty
echo ""                                                          &>/dev/tty
echo " Sentora Web login can be accessed using your server IP"   &>/dev/tty
echo " inside your web browser."                                 &>/dev/tty
echo "#########################################################" &>/dev/tty
echo "" &>/dev/tty

# We now request that the user restarts their server...
while true; do
    read -e -p "Restart your server now to complete the install (y/n)? " rsn
    case $rsn in
        [Yy]* ) break;;
        [Nn]* ) exit;
    esac
done
shutdown -r now
