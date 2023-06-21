echo "Download dotfiles project"
git clone https://github.com/montenoki/dotfiles.git ~/repo/dotfiles

echo "Install pyenv ..."
curl https://pyenv.run | bash

echo "Install paru ..."
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -ci --noconfirm
cd ..

echo "Setup SSH ..."
mkdir ~/.ssh/
ssh-keygen -t ed25519 -N "" -f ~/.ssh/ed25519.key
mkdir -p ~/.config/systemd/user/
cp ~/repo/dotfiles/dotfiles/ssh-agent.service ~/.config/systemd/user/ssh-agent.service
echo 'export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"' >> ~/.bashrc

echo "Setup ~/.bashrc ..."

if command -v bat &> /dev/null
then
    echo "alias cat=bat" >> ~/.bashrc
else
    echo "bat could not be found"
fi

if command -v btm &> /dev/null
then
    echo "alias top=btm" >> ~/.bashrc
else
    echo "btm could not be found"
fi


if command -v dust &> /dev/null
then
    echo "alias du=dust" >> ~/.bashrc
else
    echo "dust could not be found"
fi

if command -v fd &> /dev/null
then
    echo "alias find=fd" >> ~/.bashrc
else
    echo "fd could not be found"
fi

if command -v lsd &> /dev/null
then
    echo "alias ls=lsd" >> ~/.bashrc
    echo "alias tree='lsd --tree'" >> ~/.bashrc
else
    echo "lsd could not be found"
fi

if command -v sd &> /dev/null
then
    echo "alias sed=sd" >> ~/.bashrc
else
    echo "sd could not be found"
fi

if command -v zoxide &> /dev/null
then
    echo 'eval "$(zoxide init bash)"' >> ~/.bashrc
else
    echo "zoxide could not be found"
fi

if command -v pyenv &> /dev/null
then
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
    echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
    echo 'eval "$(pyenv init -)"' >> ~/.bashrc
else
    echo "pyenv could not be found"
fi

if command -v starship &> /dev/null
then
    echo 'eval "\$(starship init bash)"' >> ~/.bashrc
else
    echo "starship could not be found"
fi

if command -v nvim &> /dev/null
then
    git clone https://github.com/montenoki/nvim.git ~/.config/nvim
    mkdir ~/.virtualenvs/
    python -m venv ~/.virtualenvs/neovim
    python -m venv ~/.virtualenvs/debugpy
    ~/.virtualenvs/neovim/bin/python -m pip install --upgrade pip
    ~/.virtualenvs/debugpy/bin/python -m pip install --upgrade pip
    ~/.virtualenvs/neovim/bin/python -m pip install neovim
    ~/.virtualenvs/debugpy/bin/python -m pip install debugpy
else
    echo "nvim could not be found"
fi