#
alias ls='lsd -a'
alias tree='lsd --tree'
alias grep='grep --color=auto'
alias cat=bat
alias top=btm
alias du=dust
alias find=fd
alias sed=sd

# Add ssh-key
eval $(ssh-agent)
for k in ~/.ssh/id_ed25519; do
	if ! ssh-add -l | grep -q "$(ssh-keygen -lf "$k" | cut -d \  -f 2)"; then
		ssh-add "$k"
	fi
done

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Use Tmux only if current term program is WezTerm
if [ "$TERM_PROGRAM" = 'WezTerm' ]; then
  tmux has -t work &> /dev/null
  if [ $? != 0 ]; then
    tmux new -s work
  elif [ -z $TMUX ]; then
    tmux attach -t work
  fi
fi
