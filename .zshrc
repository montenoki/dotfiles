export ZSH=$HOME/.oh-my-zsh
export PATH="$HOME/.pyenv/bin:$PATH"

ZSH_THEME="agnoster"

COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="yyyy-mm-dd"

plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    colored-man-pages
    command-not-found
)

source $ZSH/oh-my-zsh.sh
source /usr/share/autojump/autojump.sh


alias cat=batcat

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
eval $(thefuck --alias)
eval $(thefuck --alias FUCK)