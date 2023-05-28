#!/bin/bash
# postinstall script for ovh plateform ovh.com soyoustart.com and kimsufi.com
wget http://sentora.org/install -O sentora_install.sh
chmod +x sentora_install.sh
if [ -f /etc/centos-release ]; then
yum -y update
yum -y remove bind
elif [ -f /etc/lsb-release ]; then
apt-get update
apt-get -y dist-upgrade
fi
./sentora_install.sh -t Europe/Paris -d $(hostname) -i public
echo "OK"
exit
