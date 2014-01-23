Create rpm for zpapr-util (internal apr-util for zpanel)

cd $HOME/rpmbuild/SOURCES

rm -rf apr-util-1.5.3.tar.bz2

git clone https://github.com/apache/apr-util.git apr-util-1.5.3

cd apr-util-1.5.3

git checkout 1.5.3

cd ..

tar cvjf apr-util-1.5.3.tar.bz2 apr-util-1.5.3

rm -rf apr-util-1.5.3/

wget https://github.com/zpanel/installers/raw/master/install/CentOS-6_4/compile/zpapr-util/zpapr-util.spec \

-P $HOME/rpmbuild/SPECS

rpmbuild -ba $HOME/rpmbuild/SPECS/zpapr-util.spec
Regenerate repo

createrepo --update $HOME/rpmbuild/RPMS/$(uname -m)
Install

sed -i 's/enabled=1/enabled=0/g' "/etc/yum.repos.d/CentOS-Media.repo"

yum -y update

sed -i 's/enabled=0/enabled=1/g' "/etc/yum.repos.d/CentOS-Media.repo"

yum -y update

yum -y install zpapr-util
