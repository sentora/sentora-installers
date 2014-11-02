Sentora Installers
==================

Welcome to the Sentora Installation Script Git repository, this provides a central place to store, version and distribute Sentora installer and upgrade scripts from.

## How to install Sentora ##

__This common installer is in BETA-TEST__

It supports CentOs 6 / 7 and Ubuntu 12.04 / 14.04
  
Preliminary install infos are on [Sentora Documentation](http://docs.sentora.org/index.php?node=7)

 
To install use:
```
bash <(curl -L -Ss http://sentora.org/install-beta)
```

Please report any errors that you may find to the [beta-test dedicated forum](http://forums.sentora.org/forumdisplay.php?fid=60).
Thank you.

  
#### Upgraders and removers ####

Upgraders are still here only for later use or reference. They must NOT be used.

Removers *may* work but their use is not recommended. They remove most of the packages but they are NOT leaving your OS in his initial state.


* * *
## ALL INFOS BELOW MAY BE INACURATE OR INCOMPLETE ##
* * *

## Vagrant installer/upgrader development & testing ##

#### Available OS's ####

- sentora_12.04ubuntu32 @ 192.168.33.10
- sentora_12.04ubuntu64 @ 192.168.33.11
- sentora_6.4centos32 @ 192.168.33.12
- sentora_6.4centos64 @ 192.168.33.13
- sentora_14.04ubuntu64 @ 192.168.33.15

Folders mounted to /root/sentora/{install,uninstall,upgrade}

vagrant docs : [Vagrant Docs](https://docs.vagrantup.com/v2/ "Vagrant docs")

Common vagrant commands
```bash
$ vagrant up <defined vm name> # start the VM
$ vagrant suspend <defined vm name> # Pause | suspend the VM
$ vagrant resume <defined vm name> # resume a previously paused VM
$ vagrant halt <defined vm name> #  Stop the VM
$ vagrant destroy <defined vm name> # Delete the VM
## example to launch ubuntu 14.04 64bit env @ ip 192.168.33.15
vagrant up sentora_14.04ubuntu64 &&
vagrant ssh sentora_14.04ubuntu64
```

## Official maintainers ##

The officially supported operating system installer and upgrade scripts are maintained internally by members of the official Sentora team.

We do encourage third-party installation scripts of which we will happily host on this repository and promote the use of in the event that we get interest by community members. If you are interested in maintaining an installation and upgrade script for another OS/distribution please see the *Want to contribute* section below for more information.

## Want to contribute ##

There are a couple of ways in which you can contribute, firstly you can make improvements or fix 'bugs' in the existing 'officially maintained' installers of which we feel will usually be minimal as we keep on top of these installer/upgrade scripts and frequently review them.

The other way in which you can contribute is to become an 'community maintainer' this means that you are responsible for the creation and maintenance of installation and upgrade scripts for non-official supported OSes.

In most cases you'll simply be able to copy and paste our official installer and upgrade scripts and just make the required OS/distribution specific changes such as file/directory paths and operating system/distribution specific package configuration amendments.

If you are interested in becoming an community maintainer please email [ballen@sentora.io](mailto:ballen@sentora.io) stating your interest in becoming a community maintainer and the OS/distribution that you wish to maintain.

Please be aware that community supported install and upgrade scripts that we will host and promote must adhere to the following rules:

- Must be kept up to date with the latest release of the OS.
- Will be licensed under the GPL and hosted on this repository.
- Must maintain the same user interface as our official install/upgrade scripts (eg. shell script echo's and 'read' statements must match the same wording to ensure that the installation experience across all OSes and distributions give the same user experience.)

If you have any queries regarding the above rules please feel free to contact us at: [info@sentora.org](mailto:info@sentora.org).
