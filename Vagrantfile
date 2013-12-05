# Learn vagrant http://www.vagrantup.com/

Vagrant.configure("2") do |config|
	# mount install scripts
	config.vm.synced_folder "./install/", "/root/zpanel/install/",
        	:owner =>"root", :group => "root", :mount_options => ['dmode=777,fmode=777']
	# mount uninstall scripts
	config.vm.synced_folder "./uninstall/", "/root/zpanel/uninstall/",
        	:owner =>"root", :group => "root", :mount_options => ['dmode=777,fmode=777']
	# mount upgrade scripts
	config.vm.synced_folder "./upgrade/", "/root/zpanel/upgrade/",
        	:owner =>"root", :group => "root", :mount_options => ['dmode=777,fmode=777']
	

	config.vm.provider :virtualbox do |box|
  		box.gui = false
  		box.customize ["modifyvm", :id, "--memory", "315"]
	end # box conf
#####################################################################################
# vagrant testing environments for zpanel installer & upgrader
	
	# ubuntu 12.04 32bit # IP : 192.168.33.10
	config.vm.define 'zpanel_12.04ubuntu32' do |ubuntu32|
		ubuntu32.vm.box = "ubuntu12_04-32"
		ubuntu32.vm.network :private_network, ip: "192.168.33.10"
		ubuntu32.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/precise/current/precise-server-cloudimg-i386-vagrant-disk1.box"
		ubuntu32.vm.provider :virtualbox do |vb|
			# custom virtual machine setup
        		vb.hostname = "zp32ubuntu"
    		end
	end # end define

	# ubuntu 12.04 64bit # IP : 192.168.33.11
	config.vm.define 'zpanel_12.04ubuntu64' do |ubuntu64|
		ubuntu64.vm.box = "ubuntu12_04-64"
		ubuntu64.vm.network :private_network, ip: "192.168.33.11"
		ubuntu64.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/precise/current/precise-server-cloudimg-amd64-vagrant-disk1.box"
		ubuntu64.vm.provider :virtualbox do |vb|
			# custom virtual machine setup
        		vb.hostname = "zp64ubuntu"
    		end
	end # end define

	# cento 6.4 32bit # IP : 192.168.33.12
	config.vm.define 'zpanel_6.4centos32' do |centos32|
		centos32.vm.box = "centos6.4-32"
		centos32.vm.network :private_network, ip: "192.168.33.12"
		centos32.vm.box_url = "http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.4-i386-v20131103.box"
		centos32.vm.provider :virtualbox do |vb|
			# custom virtual machine setup
        		vb.hostname = "zp32centos"
    		end
	end # end define
	# cento 6.4 64bit # IP : 192.168.33.13
	config.vm.define 'zpanel_6.4centos64' do |centos64|
		centos64.vm.box = "centos6.4-64"
		centos64.vm.network :private_network, ip: "192.168.33.13"
		centos64.vm.box_url = "http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.4-x86_64-v20130731.box"
		centos64.vm.provider :virtualbox do |vb|
			# custom virtual machine setup
        		vb.hostname = "zp64centos"
    		end
	end # end define
###################################################################
## virtual os environments for installer on beta os's
	# ubuntu 12.10 32bit virtual machine : 192.168.33.14
	config.vm.define 'zpanel_12.10ubuntu32' do |ubuntu32|
		ubuntu32.vm.box = "ubuntu12_10-32"
		ubuntu32.vm.network :private_network, ip: "192.168.33.14"
		ubuntu32.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/quantal/current/quantal-server-cloudimg-i386-vagrant-disk1.box"
		ubuntu32.vm.provider :virtualbox do |vb|
			# custom virtual machine setup
			vb.hostname = "zp32ubuntu"
	    	end
	end # end config


end # Toplevel end


