if [[ -x starship ]]; then
  eval "$(starship init zsh)"
fi
if [[ -x zoxide ]]; then
  eval "$(zoxide init zsh)"
fi
if [[ -x pyenv ]]; then
  eval "$(pyenv init -)"
fi
