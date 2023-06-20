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
	read -p "Enter a current user name for installation:" -a user_name
	enable_create_user=0
	;;
*) exit ;;
esac

read -p "Do you wish to install Nushell (y/n)?" -a yn
case $yn in
[Yy]*)
	enable_nushell=1
	read -p "Do you wishi to set Nushell as default (y/n)?" -a yn2
	case $yn2 in
	[Yy]*)
		enable_nushell_as_def=1
		;;
	[Nn]*)
		enable_nushell_as_def=0
		;;
	*) exit ;;
	esac
	;;
[Nn]*)
	enable_nushell=0
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
#                      Update System                       #
############################################################

echo "System Updating..."
pacman -Syu --noconfirm

############################################################
#                  Software Installations                  #
############################################################

echo "Software Installing..."

########################################

pacman -S ssh git bat bottom du fd gitui lsd ripgrep sd tealdeer zoxide --noconfirm

pacman -S --needed base-devel
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
cd ..

########################################
echo "Cargo ..."
sudo -u $user_name sh <<EOF
curl https://sh.rustup.rs -sSf | sh -s -- -y
EOF

if [ "$enable_nushell" -eq 1 ]; then
	echo "Nushell ..."
	sudo -u $user_name sh <<EOF
source "/home/$user_name/.cargo/env"
cargo install nu --features=dataframe
echo '$ a '"/home/$user_name/.cargo/bin/nu"
EOF
	sed -i -e '$ a '"/home/$user_name/.cargo/bin/nu" /etc/shells
	if [ "$enable_nushell_as_def" -eq 1 ]; then
		sudo -u $username sh <<EOF
chsh /home/$user_name/.cargo/bin/nu
EOF
	fi
fi

if [ "$enable_starship" -eq 1 ]; then
	echo "Starship ..."
	curl https://starship.rs/install.sh | sh -s -- -y
	sed -i -e '$ a eval "$(starship init bash)"' ~/.bashrc
	if [ "$enable_nushell" -eq 1 ]; then
		sudo -u $user_name sh <<EOF
mkdir ~/.cache/starship
starship init nu | save -f ~/.cache/starship/init.nu
sed -i -e '$ a source ~/.cache/starship/init.nu' $nu.config-path
EOF
	fi
fi
