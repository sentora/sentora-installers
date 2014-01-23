Create rpm for zpapr (internal apr for zpanel)


<code>cd $HOME/rpmbuild/SOURCES</code>

<code>rm -rf apr-1.5.0.tar.bz2</code>

<code>git clone https://github.com/apache/apr.git apr-1.5.0</code>

<code>cd apr-1.5.0</code>

<code>git checkout 1.5.0</code>

<code>cd ..</code>

<code>tar cvjf apr-1.5.0.tar.bz2 apr-1.5.0</code>

<code>rm -rf apr-1.5.0/</code>

<code>wget https://github.com/zpanel/installers/raw/master/install/CentOS-6_4/compile/zpapr/zpapr.spec \ </code>

<code>-P $HOME/rpmbuild/SPECS</code>

<code>rpmbuild -ba $HOME/rpmbuild/SPECS/zpapr.spec</code>

