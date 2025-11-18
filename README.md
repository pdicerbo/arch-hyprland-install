README
=========

Here all my config files.
Current setup:

**AwesomeWM + Picom + conky**

INSTALL SCRIPTS USAGE
------

- make a bootable USB with ArchLinux iso image and boot from it
- establish a network connection through [`iwd`](https://wiki.archlinux.org/title/Iwd) (tipically for wifi):
  - execute `iwctl`
  - execute `device list` to see the wifi device name
  - if needed, set the device powered on: `device <device_name> set-property Powered on`
  - execute `station <device_name> scan` to scan for available networks
  - execute `station <device_name> get-networks` to see the available networks
  - execute `station <device_name> connect <network_name>` to connect to the network
  - test the connection e.g. with `ping www.google.com`
- to ensure the system clock is accurate, exec:
  - *timedatectl set-ntp true*
- partition the disk; for UEFI you need a FAT32 EFI System Partition (ESP) of at least 300 MB (better would be 1GB), possibly a swap partition and then the root partition; mount the partitions; e.g.:
  ```
  > fdisk -l
  > fdisk /dev/sda
  > n .... w
  > mkfs.fat -F 32 /dev/sda1
  > mkswap /dev/sda2
  > swapon /dev/sda2
  > mkfs.ext4 /dev/sda3
  > mount /dev/sda3 /mnt
  > mount --mkdir /dev/sda1 /mnt/boot/efi
  ```
- mount it, install the basic packages and then `arch-chroot` into new system:
  ```
  > pacstrap -K /mnt base base-devel linux linux-firmware git vim
  > genfstab -U /mnt >> /mnt/etc/fstab
  > arch-chroot /mnt /bin/bash
  ```
- at this point, install git, download this repository (maybe into the /srv folder.) and execute the base packages installation script:
  ```
  > cd /srv
  > git clone https://github.com/pdicerbo/arch-hyprland-install.git
  > cd arch-hyprland-install
  > ./install_base_pkgs.sh [username] [vbox]
  ```
  the `install_base_pkgs.sh` script will install all the needed packages for a basic ArchLinux installation with Hyprland; the two parameters are optional and are the `username` to be created (default is *pierluigi*) and the `vbox` value to trigger the installation of VirtualBox guest additions (default is *no*).
- set the `root` and `username` password
  ```
  > passwd # provide as input the root password
  > passwd <username> # provide as input the user password
  ```
-execute the `user_install.sh` script as the created user:
  ```
  > su username
  > ./user_install.sh
  ```
- exit from the chroot environment, clean the environment, umount disks and reboot:
  ```
  > exit # exit from the user environment
  > cd /srv
  > rm -rf arch-hyprland-install
  > exit # exit from the chroot environment
  > umount -R /mnt
  > reboot
  ```

AUR packages to be installed after a fresh installation
------------

- [cppman](https://aur.archlinux.org/packages/cppman)
- [luajit](https://aur.archlinux.org/packages/luajit-tiktoken-bin)
- [devpod-bin](https://aur.archlinux.org/packages/devpod-bin)
- [unimatrix](https://aur.archlinux.org/packages/unimatrix-git)
