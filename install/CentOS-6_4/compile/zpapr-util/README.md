Create rpm for zpapr-util (internal apr-util for zpanel)

<code>cd $HOME/rpmbuild/SOURCES</code>

<code>rm -rf apr-util-1.5.3.tar.bz2</code>

<code>git clone https://github.com/apache/apr-util.git apr-util-1.5.3</code>

<code>cd apr-util-1.5.3</code>

<code>git checkout 1.5.3</code>

<code>cd ..</code>

<code>tar cvjf apr-util-1.5.3.tar.bz2 apr-util-1.5.3</code>

<code>rm -rf apr-util-1.5.3/</code>

<code>wget https://github.com/zpanel/installers/raw/master/install/CentOS-6_4/compile/zparp-util/zpapr-util.spec \ </code>

<code>-P $HOME/rpmbuild/SPECS</code>

<code>rpmbuild -ba $HOME/rpmbuild/SPECS/zpapr-util.spec</code>

#Regenerate repo

<code>createrepo --update $HOME/rpmbuild/RPMS/$(uname -m)</code>

#Install

<code>sed -i 's/enabled=1/enabled=0/g' "/etc/yum.repos.d/CentOS-Media.repo"</code>

<code>yum -y update</code>

<code>sed -i 's/enabled=0/enabled=1/g' "/etc/yum.repos.d/CentOS-Media.repo"</code>

<code>yum -y update</code>

<code>yum -y install zpapr-util</code>
