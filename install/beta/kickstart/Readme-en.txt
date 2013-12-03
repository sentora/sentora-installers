This is test scripts have had with virtualbox and vmware Proxmox KVM and are quite functional

You can use a netinstall iso.

Centos to edit the file isolinux / isolinux.cfg

and change this

timeout 600

by

1 timeout

In every line containing

append initrd = initrd.img ... ETC

add this

ks = cdrom :/ ks.cfg

Caution default kickstart file are set to operate in dhcp

Think about changing the configuration function have your host

For her I invite you to read docummentation kickstart you can find on google seek

Default kickstart file are also set in 32 bit

to install 64-bit change ATRIBUT i386 in x86_64
