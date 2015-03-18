#!/usr/bin/env bash
SUHOSIN_VERSION="0.9.37.1"
wget -nv -O suhosin.zip https://github.com/stefanesser/suhosin/archive/$SUHOSIN_VERSION.zip
unzip -q suhosin.zip
rm -f suhosin.zip
cd suhosin-$SUHOSIN_VERSION
phpize 
./configure 
make
make install 
cd ..
rm -rf suhosin-$SUHOSIN_VERSION
sed -i 'N;/default extension directory./a\extension=suhosin.so' /etc/php5/apache2/php.ini
