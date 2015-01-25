# Learn vagrant : http://www.vagrantup.com/
# Boxes http:// vagrantbox.es , cloud-images.ubuntu.com , atlas.hashicorp.com/
PANEL_NAME = "sentora"

# $ vagrant up ubuntu64 < default for $ vagrant up
# $ vagrant up centos6.5

Vagrant.configure("2") do |config|	
	config.vm.provider :virtualbox do |box|
  		box.gui = false
  		box.customize ["modifyvm", :id, "--memory", "512"]
	end # box conf
#####################################################################################


	# Ubuntu 14.04 64bit
	config.vm.define 'ubuntu64', primary: true do |config|
		config.vm.box = 'ubuntu_14.04_64'
		config.vm.network "public_network", ip: "192.168.1.18"
		config.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"
		config.vm.provider :virtualbox do |vb|
			vb.name = "Sentora_ubuntu64"
		end
	end

	# Centos 7 x86_64
	config.vm.define 'centos6.5', autostart: false do |config|
		config.vm.box = 'centos_6.5_x86_64'
		config.vm.network "public_network", ip: "192.168.1.19"
		config.vm.box_url = "https://github.com/2creatives/vagrant-centos/releases/download/v6.5.3/centos65-x86_64-20140116.box"
		config.vm.provider :virtualbox do |vb|
			vb.name = "Sentora_centos6.5"
		end
	end

end # Toplevel end

