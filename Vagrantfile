# Learn vagrant http://www.vagrantup.com/
PANEL_NAME = "zpanel"

Vagrant.configure("2") do |config|

  # mount install scripts
  config.vm.synced_folder ".", "/root/sentora/install/",
    :owner =>"root", :group => "root", :mount_options => ['dmode=777,fmode=777']
  # mount uninstall scripts
  config.vm.synced_folder "uninstall/", "/root/sentora/uninstall/",
    :owner =>"root", :group => "root", :mount_options => ['dmode=777,fmode=777']
  # mount upgrade scripts
  #config.vm.synced_folder "upgrade/", "/root/sentora/upgrade/",
    #:owner =>"root", :group => "root", :mount_options => ['dmode=777,fmode=777']


  # Mount Development Folders
  #ETC apache
  #config.vm.synced_folder "preconf/apache", "/etc/apache2/",
    #:owner =>"root", :group => "root", :mount_options => ['dmode=777,fmode=777']
  #ETC dovecot
  #config.vm.synced_folder "preconf/dovecot2", "/etc/dovecot/",
    #:owner =>"root", :group => "root", :mount_options => ['dmode=777,fmode=777']
  #ETC proftpd
  #config.vm.synced_folder "preconf/proftpd", "/etc/proftpd/",
    #:owner =>"root", :group => "root", :mount_options => ['dmode=777,fmode=777']
  #ETC panel
  #config.vm.synced_folder "preconf/#{PANEL_NAME}/", "/etc/#{PANEL_NAME}/",
    #:owner =>"root", :group => "root", :mount_options => ['dmode=777,fmode=777']

  config.vm.provider :virtualbox do |box|
    box.gui = false
    box.customize ["modifyvm", :id, "--memory", "512"]
  end

  #####################################################################################
  # vagrant testing environments for sentora installer & upgrader

  vms = {
    "sentora_12.04ubuntu32" => {
      :box  => "ubuntu12_04-32",
      :url  => "http://cloud-images.ubuntu.com/vagrant/precise/current/precise-server-cloudimg-i386-vagrant-disk1.box",
      :ip   => "192.168.33.10"
    },
    "sentora_12.04ubuntu64" => {
      :box  => "ubuntu12_04-64",
      :url  => "http://cloud-images.ubuntu.com/vagrant/precise/current/precise-server-cloudimg-amd64-vagrant-disk1.box",
      :ip   => "192.168.33.11"
    },
    "sentora_6.4centos32" => {
      :box  => "centos6.4-32",
      :url  => "http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.4-i386-v20131103.box",
      :ip   => "192.168.33.13"
    },
    "sentora_6.4centos64" => {
      :box  => "centos6.4-64",
      :url  => "http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.4-x86_64-v20130731.box",
      :ip   => "192.168.33.14"
    },
    "sentora_14.04ubuntu64" => {
      :box  => "ubuntu14_04-64",
      :url  => "http://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box",
      :ip   => "192.168.33.15"
    },
  }

  vms.each do |hostname, v|
    config.vm.define hostname do |conf|
      conf.vm.box = v[:box]
      conf.vm.box_url = v[:url]

      conf.vm.network :private_network, ip: v[:ip]

      conf.vm.boot_timeout = 800

      conf.vm.provision "file",
        source: "./install",
        destination: "/tmp/"

      conf.vm.provision "shell",
        inline: "chmod +x /tmp/install/install.sh && /tmp/install/install.sh -d panel.domain.com -i #{v[:ip]} -t America/New_York && rm -r /tmp/install"
    end
  end
end


