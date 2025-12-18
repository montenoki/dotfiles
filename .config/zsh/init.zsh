#!/usr/bin/env bash

if [[ -x $(which starship) ]]; then
	eval "$(starship init zsh)"
fi
if [[ -x $(which zoxide) ]]; then
	eval "$(zoxide init zsh)"
fi
if [[ -x $(which pyenv) ]]; then
	eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

if [[ -x $(which brew) ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

