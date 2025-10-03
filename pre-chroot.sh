#!/bin/bash

REPO_NAME=MyDotFiles
if mount | grep /mnt > /dev/null; then
    echo -e "\n\tperforming base installation"
else
    echo -e "\n\tcannot perform pre chroot operations. mount destination disk into /mnt folder with e.g.\n\n\tmount /dev/sda1 /mnt\n"
    exit 42
fi

pacstrap_cmd="pacstrap /mnt base base-devel linux linux-firmware"
echo -e "\n\texecuting $pacstrap_cmd...\n"
eval $pacstrap_cmd

echo -e "\n\tgenerating fstab...\n"
genfstab -U /mnt >> /mnt/etc/fstab

cp -r ../$REPO_NAME /mnt/srv
echo -e "\n\tnow continue by executing\n\n\tarch-chroot /mnt /bin/bash\n\tcd /srv/$REPO_NAME\n\t./install_base_pkgs.sh user [vbox|std_install]\n\n\tbe careful to set the appropriate locale etc..\n"