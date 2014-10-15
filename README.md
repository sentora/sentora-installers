Sentora Installers
==================

```
# WARNING #
Installers are in rebuild beta state. 

  OLDERS INSTALLER MUST BE NOT USED. 

They have been pushed in "Archive (obsolete)" directory to maintain them for reference only

This text will be removed as soon as the installer will be released.
```
# ALL THAT FOLLOWS IS NOT COMPLETE NOR ACCURATE #


Welcome to the Sentora installation script Git repository, this provides a central place to store, version and distribute Sentora installers and upgrade scripts from.

## How to install Sentora ##

The new installer and upgrade script enable you to install/upgrade Sentora directly from the command line with a single command, you no longer need to manually download the file, *CHMOD* it and then execute it etc.
They check OS and version and will not allow you to install if requirements are not met.

They are compatible with CentOs 6 and 7, ubuntu 12.04 and 14.04

#### Installation ####

```bash <(curl -Ss https://raw.githubusercontent.com/sentora/sentora-installers/1.0.0/sentora_install.sh)```

- The new installer is designed to install public server, with more checks about dns setup to ensure it will work.
  If the installer provide some warning, you MUST have knowledge enough of Linux and servers to be able to use it.
  Use it for local install only if you know what you do 

- It is STRONGLY recommended that to setup DNS for the panel PRIOR to installation.

- It installs sentora in directory /etc/sentora and /var/sentora but also setup symbolic links /etc/zpanel and /var/zpanel to provide compatibility with zpanel 10.1.1 addons.

#### More informations to install and run Sentora ####

Please refer to sentora documentation at [Sentora documentation](http://docs.sentora.org/?node=7).

In case of problem, please use [Sentora forums](http://forums.sentora.org).

#### Upgraders and removers ####

Upgraders are still here only for later use or reference. They must NOT be used.

Removers *may* work but their use is not recommended. They remove most of the packages but they are NOT leaving your OS in his initial state.



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

If you have any queries regarding the above rules please feel free to contact me at: [ballen@sentora.io](mailto:ballen@sentora.io).
