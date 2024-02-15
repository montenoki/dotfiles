# dotfiles

This directory contain the dotfiles for my system.

## Requirements

Ensure you have the following installed on your system.

### Git

```bash
brew install stow
```

## Installation

First, check out the dotfiles repo in your $HOME directory using git.

```bash
git clone git@github.com:montenoki/dotfiles.git ~
cd ~/dotfiles
```

Then use the GNU stow to create symlinks.

```bash
stow --adopt .
```
