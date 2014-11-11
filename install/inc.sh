#!/usr/bin/env bash

function sentora_init {
    sentora_source "$(sentora_os_mod_path $1)/init.sh"
}

function sentora_config {
    sentora_source "$(sentora_os_mod_path $1)/config.sh"
}

function sentora_install {
    sentora_source "$(sentora_os_mod_path $1)/install.sh"
}

function sentora_service {
    sentora_source "$(sentora_os_mod_path $1)/service.sh"
}

##
# Returns OS name (e.g. "Ubuntu" or "CentOs")
##
function sentora_os {
    if [ -f /etc/centos-release ]; then
        OS="CentOs"
    elif [ -f /etc/lsb-release ]; then
        OS=$(grep DISTRIB_ID /etc/lsb-release | sed 's/^.*=//' | tr -d '"')
    else
        OS=$(uname -s)
    fi

    echo $OS
}

##
# Returns OS version (e.g. "7")
##
function sentora_os_ver {
    if [ -f /etc/centos-release ]; then
        VERFULL=$(sed 's/^.*release //;s/ (Fin.*$//' /etc/centos-release)
        VER=${VERFULL:0:1} # return 6 or 7
    elif [ -f /etc/lsb-release ]; then
        VER=$(grep DISTRIB_RELEASE /etc/lsb-release | sed 's/^.*=//')
    else
        VER=$(uname -r)
    fi

    echo $VER
}

##
# Loads installer module
##
function sentora_mod {
    sentora_source "`dirname $0`/$1.sh"
}

##
# Returns path for OS-specific installer module
##
function sentora_os_mod_path {
    OS=$(sentora_os)
    echo "$(dirname $0)/$(sentora_lowercase $OS)/$1"
}

##
# Return input string as all lowercase
##
function sentora_lowercase {
    echo $1 | tr '[:upper:]' '[:lower:]'
}

##
# Sources file if it exists
##
function sentora_source {
    if [ -e $1 ]; then
        source $1
    fi
}

function sentora_install_pkg {
    $PACKAGE_INSTALLER $*
}
