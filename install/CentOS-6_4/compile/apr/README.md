#Create rpm for apr

<code>cd ~/rpmbuild/SOURCES</code>

<code>wget http://www.gtlib.gatech.edu/pub/apache/apr/apr-1.5.0.tar.bz2</code>

<code>rpmbuild -tb apr-1.5.0.tar.bz2</code>

#Regenerate repo

<code>cd ~/rpmbuild/RPMS/$(uname -m)</code>

<code>createrepo --update ./</code>

#Install

<code>yum -y install apr-devel</code>
