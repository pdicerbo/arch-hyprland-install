README
=========

Here all my config files.
Current setup:

**AwesomeWM + Picom + conky**

INSTALL SCRIPTS USAGE
------

- make a bootable USB with ArchLinux iso image
- establish a network connection by means of netctl utility
  - for a wireless connection, copy an example of cfg file from /etc/netctl/examples/wireless-wpa into /etc/netctl
  - modify the file and exec *netctl start my_profile*
  - test the connection e.g. with *ping www.google.com*
- to ensure the system clock is accurate, exec:
  - *timedatectl set-ntp true*
- perform these preliminary operations to partition the disk, mount it, install the basic packages and the *arch-chroot* into new system (tipically the operations are the following, adapt opportunely the partitions ids):
  - *fdisk -l*
  - *fdisk /dev/sda*
  - *n .... w*
  - *mkfs.ext4 /dev/sda1*
  - *mkswap /dev/sda2*
  - *swapon /dev/sda2*
  - *mount /dev/sda1 /mnt*
  - *pacstrap /mnt base base-devel linux linux-firmware*
  - *genfstab -U /mnt >> /mnt/etc/fstab*
  - *arch-chroot /mnt /bin/bash*
- at this point, install git, download this repository (maybe into the /srv folder.) and execute the base packages installation script:
  - *pacman -S git*
  - *cd /srv && git clone https://github.com/pdicerbo/arch-hyprland-install.git*
  - *cd arch-hyprland-install*
  - *./install_base_pkgs.sh [username] [vbox]*
- the last script will generate a user called *pierluigi* if user_name is not provided; set the *root* and *username* password, then execute:
  - *su username*
  - *./user_install.sh*
- now you are almost done; exit from the chroot environment and, if you want, copy the netctl config file:
  - *cp /etc/netctl/my_profile /mnt/etc/netctl/my_profile*
  - adopt the correct interface name (exec *netctl enable my_profile* to attempt the connection at every startup)
  - *exit*
  - *umount -R /mnt*

AUR packages to be installed after a fresh installation
------------

- [cppman](https://aur.archlinux.org/packages/cppman)
- [luajit](https://aur.archlinux.org/packages/luajit-tiktoken-bin)
- [devpod-bin](https://aur.archlinux.org/packages/devpod-bin)
