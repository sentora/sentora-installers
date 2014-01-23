Create rpm for zpapr (internal apr for zpanel)


<code>cd $HOME/rpmbuild/SOURCES</code>

<code>rm -rf apr-1.5.0.tar.bz2</code>

<code>git clone https://github.com/apache/apr.git zpapr-1.5.0</code>

<code>cd zpapr-1.5.0</code>

<code>git checkout 1.5.0</code>

<code>cd ..</code>

<code>tar cvjf zpapr-1.5.0.tar.bz2 zpapr-1.5.0</code>

<code>rm -rf zpapr-1.5.0/</code>

<code>wget https://github.com/zpanel/installers/raw/master/install/CentOS-6_4/compile/zpapr/zpapr.spec \ </code>

<code>-P $HOME/rpmbuild/SPECS</code>

<code>rpmbuild -ba $HOME/rpmbuild/SPECS/zpapr.spec</code>

#Regenerate repo

<code>createrepo --update $HOME/rpmbuild/RPMS/$(uname -m)</code>

#Install

<code>sed -i 's/enabled=1/enabled=0/g' "/etc/yum.repos.d/CentOS-Media.repo"</code>

<code>yum -y update</code>

<code>sed -i 's/enabled=0/enabled=1/g' "/etc/yum.repos.d/CentOS-Media.repo"</code>

<code>yum -y update</code>

<code>yum -y install zpapr</code>

