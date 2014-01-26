#create deb file for zpapr

<code>mkdir src</code>

<code>mkdir deb</code>

<code>sudo nano /etc/apt/sources.list</code>

and enter the following contained

careful here I put archive.ubuntu.com


you can change depending on your country

eg for france fr.archive.ubuntu.com

<code>
# main restricted
deb http://archive.ubuntu.com/ubuntu/ precise main restricted
deb http://security.ubuntu.com/ubuntu precise-security main restricted
deb http://archive.ubuntu.com/ubuntu/ precise-updates main restricted

Dépôts of sources of main restricted
deb-src http://archive.ubuntu.com/ubuntu/ precise main restricted
deb-src http://security.ubuntu.com/ubuntu precise-security main restricted
deb-src http://archive.ubuntu.com/ubuntu/ precise-updates main restricted

# universe multiverse
deb http://archive.ubuntu.com/ubuntu/ precise universe multiverse
deb http://security.ubuntu.com/ubuntu precise-security universe multiverse
deb http://archive.ubuntu.com/ubuntu/ precise-updates universe multiverse

# Dépôts of sources of universe multiverse
deb-src http://archive.ubuntu.com/ubuntu/ precise universe multiverse
deb-src http://security.ubuntu.com/ubuntu precise-security universe multiverse
deb-src http://archive.ubuntu.com/ubuntu/ precise-updates universe multiverse

# Commercial Partner
deb http://archive.canonical.com/ubuntu precise partner

# Dépôts of Sources of Commercial Partner
deb-src http://archive.canonical.com/ubuntu precise partner</code>


<code>sudo apt-get update</code>

<code>sudo apt-get -y dist-upgrade</code>


<code>sudo reboot</code>

<code>sudo apt-get -y install python-software-properties</code>

<code>sudo add-apt-repository ppa:git-core/ppa -y</code>

<code>sudo apt-get update</code>

<code>sudo apt-get -y install git-core</code>

<code>sudo apt-get -y install build-essential</code>

<code>sudo apt-get -y build-dep apr</code>

<code>cd src</code>


<code>git clone https://github.com/apache/apr.git</code>

<code>cd apr</code>

<code>git checkout 1.5.0</code>

<code>./buildconf</code>

<code>./configure --prefix=/etc/zpanel/bin/apr</code>

<code>make</code>

<code>sudo make install</code>
