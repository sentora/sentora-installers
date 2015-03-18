#!/bin/bash
# postinstall script for ovh plateform ovh.com soyoustart.com and kimsufi.com
# temporary accept pull request comment
wget https://github.com/andykimpe/sentora-installers/raw/master/sentora_install.sh
# temporary accept pull request uncomment
#wget https://github.com/sentora/sentora-installers/raw/master/sentora_install.sh
chmod +x sentora_install.sh
./sentora_install.sh -t Europe/Paris -d $(hostname) -i public -p 56
echo "OK"
exit
