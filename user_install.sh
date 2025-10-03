#!/bin/bash

echo -e "\n\tfinalizing new user environment\n"

set -ex

cd $HOME
git clone --branch topic/hyprland --bare https://github.com/pdicerbo/dotfiles.git $HOME/.dotfiles-bare-repo
git --git-dir=$HOME/.dotfiles-bare-repo --work-tree=$HOME checkout -f

export PATH=$PATH:$HOME/.scripts

if [[ $# -eq 1 ]] ; then
    # this execution is for root user, so we can stop here;
    # the final user is expected to install other packages
    exit 0
fi

echo -e "\n\tinstalling Google Chrome...\n"
gchrome_upgrade

LINK_FOLDER_ROOT=$HOME
echo -e "\n\tcreating link to shared folder into $LINK_FOLDER_ROOT\n"
mkdir -p $LINK_FOLDER_ROOT
ln -s /media/sf_shared $LINK_FOLDER_ROOT/shared

echo -e "\n\tremember to remove the original repo folder!\n"
