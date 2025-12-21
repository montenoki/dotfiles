# 设置默认编辑器
export EDITOR="nvim"

# 命令替换
alias cat="bat"
alias du="dust"
alias ls="lsd -a"
alias tree="lsd --tree"
alias btop="btm"

# 常用命令简写
alias b="brew"
alias n="nvim"

# 目录导航（空格开头不记录历史）
alias cd=" cd"
alias ..=" cd ..; ls"
alias ...=' cd ..; cd ..; ls'
alias ....=' cd ..; cd ..; cd ..; ls'
alias cd..='..'
alias cd...='...'
alias cd....='....'

alias rm=" rm"

# tmux快捷启动
alias t="tmux new-session -A -s"
