#!/usr/bin/env bash
#
# Sentora upgrade 1.0.4 - missing packages for existing installs
#

# Ensure the OS is compatible with the launcher
if [ -f /etc/centos-release ]; then
    OS="CentOs"
    VERFULL=$(sed 's/^.*release //;s/ (Fin.*$//' /etc/centos-release)
    VER=${VERFULL:0:1} # return 6 or 7
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

echo "Detected : $OS  $VER  $ARCH"

if [[ "$OS" = "CentOs" && ("$VER" = "6" || "$VER" = "7" ) || 
      "$OS" = "Ubuntu" && ("$VER" = "12.04" || "$VER" = "14.04" ) || 
      "$OS" = "Debian" && ("$VER" = "7" || "$VER" = "8" ) ]] ; then
    echo "Ok."
else
    echo "Sorry, this OS is not supported by Sentora." 
    exit 1
fi

if [[ "$OS" = "CentOs" ]] ; then
    PACKAGE_INSTALLER="yum -y -q install"
    PACKAGE_REMOVER="yum -y -q remove"
elif [[ "$OS" = "Ubuntu" || "$OS" = "Debian" ]]; then
    PACKAGE_INSTALLER="apt-get -yqq install"
    PACKAGE_REMOVER="apt-get -yqq remove"
    export DEBIAN_FRONTEND=noninteractive
fi

if [[ "$OS" = "CentOs" ]] ; then
    $PACKAGE_INSTALLER e2fsprogs ca-certificates cronie crontabs
elif [[ "$OS" = "Ubuntu" || "$OS" = "Debian" ]]; then
    $PACKAGE_INSTALLER e2fslibs ca-certificates cron
fi

chattr -i /etc/resolv.conf