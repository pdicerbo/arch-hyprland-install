#!/bin/bash

if [[ $# -ne 2 ]]; then
    echo -e "\n\tUsage\n\t  $0 [username] [vbox|...]\n\n\tif vbox is passed, some other steps will be performed"
    exit 2
fi

echo -e "\n\tinit operations\n"

set -ex

# set localtime
ln -sf /usr/share/zoneinfo/Europe/Rome /etc/localtime
hwclock --systohc --utc

# choose locale language
# by commenting the undesired choice
# LOCALE="it_IT.UTF-8"
LOCALE="en_US.UTF-8"

echo "$LOCALE UTF-8" > /etc/locale.gen
locale-gen

echo "LANG=$LOCALE" > /etc/locale.conf

# set hostname and hosts
echo "ArchLinux" > /etc/hostname

echo "127.0.0.1   localhost" >> /etc/hosts
echo "::1         localhost" >> /etc/hosts
echo "127.0.1.1   ArchLinux.localdomain	ArchLinux" >> /etc/hosts

# adjust time
# timedatectl set-ntp true

echo -e "\n\tbase system upgrade\n"
# upgrade the system
pacman -Suy --noconfirm

echo -e "\n\tinstall network utilities\n"
pacman -S --noconfirm iw openssh
if [[ $2 == "vbox" ]] ; then
    pacman -S --noconfirm wpa_supplicant dialog dhcpcd netctl
else
    pacman -S --noconfirm iwd
    mkdir /etc/iwd
    echo -e "[General]\nEnableNetworkConfiguration=true\n" > /etc/iwd/main.conf
    echo -e "[Network]\nNameResolvingService=systemd\n" >> /etc/iwd/main.conf
    systemctl enable iwd.service
fi

# install grub
echo -e "\n\tinstall GRUB bootloader\n"
pacman -S --noconfirm grub dosfstools os-prober fuse2
grub-install --target=i386-pc /dev/sda
sed -i 's/ quiet//' /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg

echo -e "\n\tinstall hyprland-related packages\n"
# install hyprland stuff
pacman -S --noconfirm hyprland waybar foot foot-terminfo swaync xdg-desktop-portal-hyprland hyprpolkitagent qt5-wayland qt6-wayland hyprpaper wofi rofi hyprpicker cliphist dolphin hypridle hyprlock hyprshot

echo -e "\n\tinstall audio utils\n"
# audio utils
pacman -S --noconfirm pipewire wireplumber pipewire-pulse pamixer cava

echo -e "\n\tinstall base user utilities\n"
# user utils
pacman -S --noconfirm git git-delta sudo wget inetutils bind alacritty

echo -e "\n\tinstall base development utils\n"
# development utils
pacman -S --noconfirm gcc clang make cmake linux-headers perl python3 python-pip docker awk vim tmux tldr fzf ncdu neovim go

echo -e "\n\tinstall some other utilities\n"
# monitor utils
pacman -S --noconfirm ctop dive bat btop atop iftop procs glances fastfetch

# neovim utils
pacman -S --noconfirm ripgrep fd luarocks nodejs npm lazygit lynx

# other utils
pacman -S --noconfirm poppler ristretto cmatrix imagemagick

echo -e "\n\tinstall some fonts\n"
pacman -S --noconfirm ttf-dejavu ttf-dejavu-nerd ttf-nerd-fonts-symbols noto-fonts gnu-free-fonts ttf-anonymous-pro ttf-jetbrains-mono-nerd ttf-font-awesome

echo -e "\n\tenabling/starting docker service\n"
systemctl enable docker.service
systemctl start  docker.service

if [[ $2 == "vbox" ]] ; then
    echo -e "\n\tinstall virtualbox utils\n"
    pacman -S --noconfirm virtualbox-guest-utils

    echo -e "\n\tenabling/starting vbox service\n"
    systemctl enable vboxservice.service
    systemctl start  vboxservice.service

    echo -e "\n\tadding default shared folder into /etc/fstab\n"
    echo "shared  /media/sf_shared  vboxsf  uid=1000,gid=1000,rw,dmode=700,fmode=600,noauto,x-systemd.automount" >> /etc/fstab
else
    echo -e "\n\tcontinue with default installation\n"
fi

echo -e "\n\tenabling systemd-resolved.service at startup\n"
systemctl enable systemd-resolved.service
systemctl start  systemd-resolved.service

input_user=$1

echo -e "\n\tadd new user $input_user\n"
useradd -m --groups root,wheel,docker $input_user

echo -e "$input_user ALL=(ALL) NOPASSWD:ALL\n" > /etc/sudoers.d/$input_user

echo -e "\n\tadd basic user utilities to root user\n"
./user_install.sh "ROOT"

cp bash_files/root_bashrc $HOME/.bashrc

if [[ $2 == "vbox" ]] ; then
    echo -e "\n\tadopting the default netctl profile for wired connection..\n"
    cd /etc/netctl/
    cp examples/ethernet-dhcp .
    sed -i 's/Interface=eth0/Interface=enp0s3/' ethernet-dhcp
    netctl enable ethernet-dhcp
    cd -
else
    echo -e "\n\tremember to copy a valid netctl profile for wireless connection and enable it.."
fi
echo -e "\n\tremember to set the new user [$input_user] and root password!\n\tjust exec the following command:\n\tpasswd [username]\n\n\tthen continue with:\n\tsu $input_user\n\t./user_install.sh\n"
