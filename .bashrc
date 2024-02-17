#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '
. "$HOME/.cargo/env"
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
eval $(ssh-agent)
for k in ~/.ssh/id_rsa; do
	if ! ssh-add -l | grep -q "$(ssh-keygen -lf "$k" | cut -d \  -f 2)"; then
		ssh-add "$k"
	fi
done
alias cat=bat
alias top=btm
alias du=dust
alias find=fd
alias ls=lsd
alias tree='lsd --tree'
alias sed=sd

alias nvimdb='XDG_CONFIG_HOME=$HOME/repo/nvimdb/.config XDG_DATA_HOME=$HOME/repo/nvimdb/.data nvim'

eval "$(zoxide init bash)"
export PYENV_ROOT="$HOME/.pyenv"
export PATH=$HOME/go/bin:$PATH
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(starship init bash)"
