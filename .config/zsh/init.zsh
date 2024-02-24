if [[ -x `which starship` ]]; then
  eval "$(starship init zsh)"
fi
if [[ -x `which zoxide` ]]; then
  eval "$(zoxide init zsh)"
fi
if [[ -x `which pyenv` ]]; then
  eval "$(pyenv init -)"
fi

if [[ -x `which neofetch` ]]; then
  eval "$(neofetch)"
fi
