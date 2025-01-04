#!/usr/bin/env bash

# 设置默认编辑器
export EDITOR="nvim"

# 现代化命令替换
alias cat="bat"
alias du="dust"
alias find="fd"
alias ls="lsd -a"
alias top="btm"
alias tree="lsd --tree"

alias grep="grep --color=auto"

# 常用命令简写
alias b="brew"
alias g="git"

# 目录导航（空格开头不记录历史）
alias cd=" cd"
alias ..=" cd ..; ls"
alias ...=' cd ..; cd ..; ls'
alias ....=' cd ..; cd ..; cd ..; ls'
alias cd..='..'
alias cd...='...'
alias cd....='....'

# tmux快捷启动
alias t="tmux new-session -A -s"
