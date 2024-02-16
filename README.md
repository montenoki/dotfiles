# dotfiles

This directory contain the dotfiles for my system.

## Requirements

Ensure you have the following installed on your system.

- stow

- tmux

- neovim

```bash
brew install stow tmux neovim
```

## Installation

### setup dotfiles

First, check out the dotfiles repo in your $HOME directory using git.

```bash
git clone git@github.com:montenoki/dotfiles.git ~
cd ~/dotfiles
```

Then use the GNU stow to create symlinks.

```bash
stow --adopt .
```

### tmux

Go tmux and Press "prefix + I" to install tmux plugins.
