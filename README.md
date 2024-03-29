<!-- markdownlint-disable MD013 -->
<!-- markdownlint-disable MD033 -->
<!-- markdownlint-disable MD033 -->

# dotfiles

Dotfiles for my system.

## Requirements

<details closed>

<summary>
  Ensure you have the following installed on your system.
</summary>

- **coreutils** (mac): GNU File, Shell, and Text utilities

- **stow**: Organize software neatly under a single directory tree (e.g. /usr/local)

- **tmux**: Terminal multiplexer

- **neovim**: Ambitious Vim-fork focused on extensibility and agility

- **neofetch**: Fast, highly customisable system info script

- **lsd**: Clone of ls with colorful output, file type icons, and more

- **bat**: Clone of cat(1) with syntax highlighting and Git integration

- **bottom**: Yet another cross-platform graphical process/system monitor

- **dust**: More intuitive version of du in rust

- **fd**: Simple, fast and user-friendly alternative to find

- **sd**: Intuitive find & replace CLI

- **starship**: Cross-shell prompt for astronauts

- **zoxide**: Shell extension to navigate your filesystem faster

- **zsh**: UNIX shell (command interpreter)

</details>

### Mac

```bash
brew install lsd bat bottom dust fd sd zoxide coreutils stow tmux neovim neofetch starship
```

### Arch

```bash
sudo pacman -S lsd bat bottom dust fd sd zoxide stow tmux neovim git zsh starship neofetch
```

## Installation

### Set ZSH as default shell (optional)

```bash
chsh -s $(which zsh)
```

### Setup dotfiles

First, check out the dotfiles repo in your $HOME directory using git.

#### ssh

```bash
git clone --recursive git@github.com:montenoki/dotfiles.git ~/dotfiles && cd ~/dotfiles
```

#### http

```bash
git clone --recursive https://github.com/montenoki/dotfiles.git ~/dotfiles && cd ~/dotfiles
```

Then use the GNU stow to create symlinks.

```bash
stow --adopt .
```

### Setup tmux (optional)

Clone tpm

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Run tmux and Press "prefix + I" to install tmux plugins.

### Setup neovim (optional)

Refer to my [Neovim configuration repo](https://github.com/montenoki/nvim).
