#!/bin/bash

############################################################
#                      User Interface                      #
############################################################

read -p "Enter new user name:" user_name
echo "Enter new passwd for $user_name:"
read -s user_passwd
echo "Retype new passwd:"
read -s user_passwd_confirm

if [ $user_passwd != $user_passwd_confirm ]; then
    echo "Sorry, passwords do not match."
    echo "Exit autosetup script..."
    exit 1
fi

############################################################
#                      Update System                       #
############################################################

echo "System Updating..."
pacman -Syu --noconfirm

############################################################
#                      Creat New User                      #
############################################################

echo "New User creating..."
# wheel附加组可sudo, 以root用户执行命令; -m同时创建$HOME
useradd -m -G wheel -s /bin/bash $user_name
(
    echo $user_passwd_confirm
    sleep 1
    echo $user_passwd
) | passwd $user_name

sed -e 's/^#\s\(%wheel\s\+ALL=(ALL:ALL)\s\+ALL\)/\1/' /etc/sudoers | EDITOR=tee visudo >/dev/null

############################################################
#                  Software Installations                  #
############################################################

echo "Software Installing..."

sudo -u $user_name echo "1" | sudo -u $user_name curl https://sh.rustup.rs -sSf | sudo -u $user_name sh -s -- y
# pacman -S git

