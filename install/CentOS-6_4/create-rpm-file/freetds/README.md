#Create rpm for freetds

<code>sudo yum -y install readline-devel gnutls-devel</code>

<code>wget http://dl.fedoraproject.org/pub/epel/6/SRPMS/freetds-0.91-2.el6.src.rpm -P $HOME/rpmbuild/SRPMS</code>

<code>rpmbuild --rebuild $HOME/rpmbuild/SRPMS/freetds-0.91-2.el6.src.rpm</code>

#Regenerate repo

<code>createrepo --update $HOME/rpmbuild/RPMS/$(uname -m)</code>

#Install

<code>sudo sed -i 's/enabled=1/enabled=0/g' "/etc/yum.repos.d/CentOS-Media.repo"</code>

<code>sudo yum -y update</code>

<code>sudo sed -i 's/enabled=0/enabled=1/g' "/etc/yum.repos.d/CentOS-Media.repo"</code>

<code>sudo yum -y update</code>

<code>sudo yum -y install freetds-devel</code>
