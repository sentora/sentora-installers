# Learn vagrant http://www.vagrantup.com/
PANEL_NAME = "zpanel"

Vagrant.configure("2") do |config|

	# mount install scripts
	config.vm.synced_folder "./install/", "/root/sentora/install/",
        	:owner =>"root", :group => "root", :mount_options => ['dmode=777,fmode=777']
	# mount uninstall scripts
	config.vm.synced_folder "./uninstall/", "/root/sentora/uninstall/",
        	:owner =>"root", :group => "root", :mount_options => ['dmode=777,fmode=777']
	# mount upgrade scripts
	config.vm.synced_folder "./upgrade/", "/root/sentora/upgrade/",
        	:owner =>"root", :group => "root", :mount_options => ['dmode=777,fmode=777']
	

    # Mount Development Folders
    #ETC apache
    config.vm.synced_folder "./Dev/Etc/apache2/", "/etc/apache2/",
            	:owner =>"root", :group => "root", :mount_options => ['dmode=777,fmode=777']
    #ETC dovecot
    config.vm.synced_folder "./Dev/Etc/dovecot/", "/etc/dovecot/",
               	:owner =>"root", :group => "root", :mount_options => ['dmode=777,fmode=777']
    #ETC proftpd
    config.vm.synced_folder "./Dev/Etc/proftpd/", "/etc/proftpd/",
                :owner =>"root", :group => "root", :mount_options => ['dmode=777,fmode=777']
    #ETC panel
    config.vm.synced_folder "./Dev/Etc/#{PANEL_NAME}/", "/etc/#{PANEL_NAME}/",
                :owner =>"root", :group => "root", :mount_options => ['dmode=777,fmode=777']

	config.vm.provider :virtualbox do |box|
  		box.gui = false
  		box.customize ["modifyvm", :id, "--memory", "512"]
	end # box conf
#####################################################################################
# vagrant testing environments for sentora installer & upgrader
	
	# ubuntu 12.04 32bit # IP : 192.168.33.10
	config.vm.define 'sentora_12.04ubuntu32' do |config|
		config.vm.box = "ubuntu12_04-32"
		config.vm.network :private_network, ip: "192.168.33.10"
		config.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/precise/current/precise-server-cloudimg-i386-vagrant-disk1.box"
		config.vm.provider :virtualbox do |vb|
			# custom virtual machine setup
        		vb.hostname = "sentora-32-ubuntu"
        		config.vm.boot_timeout = 800
    		end
	end # end define

	# ubuntu 12.04 64bit # IP : 192.168.33.11
	config.vm.define 'sentora_12.04ubuntu64' do |config|
		config.vm.box = "ubuntu12_04-64"
		config.vm.network :private_network, ip: "192.168.33.11"
		config.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/precise/current/precise-server-cloudimg-amd64-vagrant-disk1.box"
		config.vm.provider :virtualbox do |vb|
			# custom virtual machine setup
        		vb.hostname = "sentora-64-ubuntu"
    		end
	end # end define

	# cento 6.4 32bit # IP : 192.168.33.12
	config.vm.define 'sentora_6.4centos32' do |config|
		config.vm.box = "centos6.4-32"
		config.vm.network :private_network, ip: "192.168.33.12"
		config.vm.box_url = "http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.4-i386-v20131103.box"
		config.vm.provider :virtualbox do |vb|
			# custom virtual machine setup
        		vb.hostname = "sentora-32-centos"
    		end
	end # end define
	# cento 6.4 64bit # IP : 192.168.33.13
	config.vm.define 'sentora_6.4centos64' do |config|
		config.vm.box = "centos6.4-64"
		config.vm.network :private_network, ip: "192.168.33.13"
		config.vm.box_url = "http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.4-x86_64-v20130731.box"
		config.vm.provider :virtualbox do |vb|
			# custom virtual machine setup
        		vb.hostname = "sentora-64-centos"
    		end
	end # end define
###################################################################
## virtual os environments for installer on beta os's
	# ubuntu 12.10 32bit virtual machine : 192.168.33.14
	config.vm.define 'sentora_12.10ubuntu32' do |config|
		config.vm.box = "ubuntu12_10-32"
		config.vm.network :private_network, ip: "192.168.33.14"
		config.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/quantal/current/quantal-server-cloudimg-i386-vagrant-disk1.box"
		config.vm.provider :virtualbox do |vb|
			# custom virtual machine setup
			vb.hostname = "sentora-32-ubuntu"
	    end
	end # end config

########################################
# ubuntu 14.04 64bit # IP : 192.168.33.15
    config.vm.define 'sentora_14.04ubuntu64' do |config|
        config.vm.box = "ubuntu14_04-64"
        config.vm.network :private_network, ip: "192.168.33.15"
        config.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"
        config.vm.provider :virtualbox do |vb|
        	# custom virtual machine setup
            vb.hostname = "sentora-64-ubuntu"
        end
    end # end config

end # Toplevel end


