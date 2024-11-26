#!/bin/bash
# postinstall script for ovh plateform ovh.com soyoustart.com and kimsufi.com
#for centos 6 centos 7 ubuntu old
wget http://sentora.org/install -O sentora_install.sh
chmod +x sentora_install.sh
if [ -f /etc/centos-release ]; then
yum -y update
yum -y remove bind
elif [ -f /etc/lsb-release ]; then
export DEBIAN_FRONTEND=noninteractive
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get -y dist-upgrade
fi
./sentora_install.sh -t Europe/Paris -d $(hostname) -i public
echo "OK"
exit
