#!/bin/bash

############################################################
#                      User Interface                      #
############################################################

read -p  "Do you wish to create a new user (y/n)?" -a yn
case $yn in
[Yy]* )
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
[Nn]* )
    read -p "Enter a current user name for installation:" -a user_name
    ;;
*) exit;;
esac

read -p "Do you wish to install Nushell (y/n)?" -a yn
case $yn in
    [Yy]*)
        $enable_nushell=true
		;;
	[Nn]*)
		$enable_nushell=false
		;;
    *) exit;;
esac

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
