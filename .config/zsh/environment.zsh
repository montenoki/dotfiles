#!/usr/bin/env bash

# XDG 规范目录
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="${HOME}/.local/share"

export ZSH_CONFIG="$XDG_CONFIG_HOME/zsh"
export ZSH_CACHE="$XDG_CACHE_HOME/zsh"

export PYENV_ROOT="$HOME/.pyenv"

[ -d "$ZSH_CACHE" ] || mkdir -p "$ZSH_CACHE"

# executable search path
path_append() {
    # First check if the directory exists
    if [ -d "$1" ]; then
        # Add path to $PATH if path not exist in PATH
        case ":$PATH:" in
        *:"$1":*) ;;
        *)
            export PATH="${PATH:+$PATH:}$1"  # 追加到末尾
            ;;
        esac
    fi
}

path_prepend() {
    # First check if the directory exists
    if [ -d "$1" ]; then
        # Add path to $PATH if path not exist in PATH
        case ":$PATH:" in
        *:"$1":*) ;;
        *)
            export PATH="$1${PATH:+:$PATH}"  # 前置到开头
            ;;
        esac
    fi
}

# 低优先级的路径用 append（先设置）
path_append "/usr/local/sbin"
path_append "/snap/bin"

# Homebrew 环境
if [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# pyenv
if [[ -d "$PYENV_ROOT/bin" ]]; then
	path_prepend "$PYENV_ROOT/bin"
fi

# Rust
if [[ -e "$HOME/.cargo/env" ]]; then
	. "$HOME/.cargo/env"
fi

# 高优先级的路径用 prepend
path_prepend "$HOME/.local/sbin"
path_prepend "$HOME/.local/bin"

DATE=$(date +%Y-%m-%d)
export DATE

# Import API KEY
if [[ -f "$HOME/.config/.env" ]]; then
    export $(cat "$HOME/.config/.env" | xargs)
else
    echo "Warning: ~/.config/.env file not found" >&2
fi
