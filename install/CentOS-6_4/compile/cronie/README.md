#create rpm for cronie

<code>yum -y install pam-devel audit-libs-devel</code>


<code>wget ftp://bo.mirror.garr.it/pub/1/slc/updates/slc6X/SRPMS/cronie-1.4.4-12.el6.src.rpm \ </code>

<code>-P $HOME/rpmbuild/SRPMS</code>

<code>rpmbuild --rebuild $HOME/rpmbuild/SRPMS/cronie-1.4.4-12.el6.src.rpm</code>

#Regenerate repo

<code>createrepo --update $HOME/rpmbuild/RPMS/$(uname -m)</code>

#Install

<code>sed -i 's/enabled=1/enabled=0/g' "/etc/yum.repos.d/CentOS-Media.repo"</code>

<code>yum -y update</code>

<code>sed -i 's/enabled=0/enabled=1/g' "/etc/yum.repos.d/CentOS-Media.repo"</code>

<code>yum -y update</code>

<code>yum -y install cronie cronie-anacron crontabs</code>
