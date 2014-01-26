#create deb file for zpapr

<code>mkdir $HOME/src</code>

<code>mkdir $HOME/deb</code>

<code>sudo nano /etc/apt/sources.list</code>

edit your depot list http://doc.ubuntu-fr.org/depots_precise

minimal required Main Restricted Universe Multiverse partner + all source activate


<code>sudo apt-get update</code>

<code>sudo apt-get -y dist-upgrade</code>


<code>sudo reboot</code>

<code>sudo apt-get -y install python-software-properties</code>

<code>sudo add-apt-repository ppa:git-core/ppa -y</code>

<code>sudo apt-get update</code>

<code>sudo apt-get -y install git-core</code>

<code>sudo apt-get -y install build-essential wget</code>

<code>sudo apt-get -y build-dep apr</code>

<code>cd src</code>


<code>git clone https://github.com/apache/apr.git</code>

<code>cd apr</code>

<code>git checkout 1.5.0</code>

<code>./buildconf</code>

<code>mkdir include/private/</code>

<code>./configure --prefix=/etc/zpanel/bin/apr</code>

<code>make</code>

<code>sudo make install</code>

<code>cd $HOME/deb</code>

<code>mkdir -p zpapr/etc/zpanel/bin/apr</code>

<code>cp -R /etc/zpanel/bin/apr/* zpapr/etc/zpanel/bin/apr</code>

<code>sudo rm -rf /etc/zpanel/bin/apr</code>

<code>mkdir zpapr/DEBIAN</code>

<code>wget https://github.com/zpanel/installers/raw/master/install/Ubuntu-12_04/create-deb-file/zpapr/control-$(uname -m) \ </code>

<code>-O zpapr/DEBIAN/control</code>

<code>chmod -R 755 zpapr/*</code>

<code>dpkg-deb --build zpapr</code>

<code>rm -rf zpapr/</code>
