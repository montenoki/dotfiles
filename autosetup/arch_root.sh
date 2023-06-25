#!/bin/bash

############################################################
#                      User Interface                      #
############################################################

read -p "Do you wish to create a new user (y/n)?" -a yn
case $yn in
[Yy]*)
	read -p "Enter new user name:" user_name
	echo "Enter new passwd for $user_name:"
	read -s user_passwd
	echo "Retype new passwd:"
	read -s user_passwd_confirm
	if [ "$user_passwd" != "$user_passwd_confirm" ]; then
		echo "Sorry, passwords do not match."
		echo "Exit autosetup script..."
		exit 1
	fi
	enable_create_user=1
	;;
[Nn]*)
	read -p "Enter an existing user for installation:" -a user_name
	enable_create_user=0
	;;
*) exit ;;
esac

read -p "Do you wish to install Starship (y/n)?" -a yn
case $yn in
[Yy]*)
	enable_starship=1
	;;
[Nn]*)
	enable_starship=0
	;;
*) exit ;;
esac

############################################################
#                      Creat New User                      #
############################################################

if [ "$enable_create_user" -eq 1 ]; then
	echo "New User creating..."
	useradd -m -G wheel -s /bin/bash $user_name
	(
		echo $user_passwd_confirm
		sleep 1
		echo $user_passwd
	) | passwd $user_name
	sed -e 's/^#\s\(%wheel\s\+ALL=(ALL:ALL)\s\+ALL\)/\1/' /etc/sudoers | EDITOR=tee visudo >/dev/null
fi

############################################################
#                      Installations                       #
############################################################

echo "System Updating..."
pacman -Syyu --noconfirm

echo "Installing..."
pacman -S --needed base-devel zlib xz tk --noconfirm
pacman -S openssh openssl git python python-pip go nodejs npm r --noconfirm
pacman -S bat bottom dust fd  lsd ripgrep sd tealdeer zoxide --noconfirm
pacman -S wget rust zellij --noconfirm
pacman -S neovim gitui --noconfirm

if [ "$enable_starship" -eq 1 ]; then
	echo "Starship ..."
	curl https://starship.rs/install.sh | sh -s -- -y
fi

echo "Software Setup..."
systemctl enable sshd
systemctl start sshd
