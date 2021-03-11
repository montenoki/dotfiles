#!/bin/bash

sudo apt update && sudo apt upgrade -y

sudo apt install curl git zsh bat python3-pip -y

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
chsh -s /bin/zsh

cd ~ && wget https://github.com/montenoki/auto_setup/blob/main/.zshrc_gcp -O .zshrc

python3 -m pip install --upgrade pip

sudo apt autoremove
sudo apt autoclean
