# https://superuser.com/questions/403355/how-do-i-get-searching-through-my-command-history-working-with-tmux-and-zshell
# Use nvim as the default editor
export EDITOR="nvim"
# But still use emacs-style zsh bindings
bindkey -e

# Replace standard command with the better one.
alias cat="bat"
alias du="dust"
alias find="fd"
alias ls="lsd -a"
alias sed="sd"
alias top="btm"
alias tree="lsd --tree"
alias vi="nvim"
alias vim="nvim"

alias grep="grep --color=auto"

# Shortcuts
alias b="brew"
alias g="git"

alias cd=" cd" # Start with a space to be ignored in history
alias ..=" cd ..; ls"
alias ...=' cd ..; cd ..; ls'
alias ....=' cd ..; cd ..; cd ..; ls'
alias cd..='..'
alias cd...='...'
alias cd....='....'
