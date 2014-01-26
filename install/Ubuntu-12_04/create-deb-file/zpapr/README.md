#create deb file for zpapr

<code>mkdir src</code>

<code>mkdir deb</code>

<code>cd src</code>

<code>git clone https://github.com/apache/apr.git</code>

<code>cd apr</code>

<code>./configure --prefix=/etc/zpanel/bin/apr</code>

<code>make</code>

<code>sudo make install</code>
