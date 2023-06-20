#!/bin/bash

############################################################
#                      User Interface                      #
############################################################

echo "Do you wish to create a new user (y/n)?"
select yn in "y" "n"; do
	case $yn in
	Yes | yes | Y | y)
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
		;;
	No | no | N | n)
		read -p "Enter a current user name for installation:" user_name
		;;
	esac
done

echo "Do you wish to install Nushell (y/n)?"
select yn in "y" "n"; do
	case $yn in
	Yes | yes | Y | y)
		$enable_nushell=true
		;;
	No | no | N | n)
		$enable_=false
		;;
	esac
done

############################################################
#                      Update System                       #
############################################################

echo "System Updating..."
pacman -Syu --noconfirm

############################################################
#                      Creat New User                      #
############################################################

echo "New User creating..."
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

########################################

pacman -S git bat bottom du fd gitui lsd ripgrep sd tealdeer zoxide --noconfirm

########################################
echo "Cargo ..."
sudo -u $user_name sh <<EOF
curl https://sh.rustup.rs -sSf | sh -s -- -y
EOF

if [ $enable_nushell=true ]; then
	echo "Nushell ..."
	sudo -u $user_name sh <<EOF
cargo install nu --features=dataframe
sed -e "/home/$user_name/.cargo/bin/nu" /etc/shells
chsh /home/$user_name/.cargo/bin/nu
EOF
fi

if [ $enable_starship=true ]; then
    echo "Starship ..."
sudo -u $user_name sh <<EOF
curl https://starship.rs/install.sh | sh
sed -e 'eval "$(starship init bash)"' ~/.bashrc
mkdir ~/.cache/starship
starship init nu | save -f ~/.cache/starship/init.nu
sed -e 'source ~/.cache/starship/init.nu' $nu.config-path
EOF
