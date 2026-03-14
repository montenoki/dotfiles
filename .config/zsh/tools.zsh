# ============================================================================
# 开发工具初始化（幂等 — 多次 source 安全）
# 注意：此文件依赖 environment.zsh 先行加载（提供 NVM_DIR、PYENV_ROOT）
# ============================================================================
(( ${+_TOOLS_LOADED} )) && return
typeset -g _TOOLS_LOADED=1

# Homebrew
if [[ "$OSTYPE" == darwin* ]]; then
    [[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# NVM（Node Version Manager）
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
    source "$NVM_DIR/nvm.sh"
    [[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"
fi

# Pyenv
if command -v pyenv &>/dev/null; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi
