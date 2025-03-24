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
            export PATH="${PATH:+$PATH:}$1"
            ;;
        esac
    fi
}

path_append "/usr/local/sbin"
path_append "$HOME/.local/bin"
path_append "$HOME/.local/sbin"
path_append "/snap/bin"


if [[ -d "$PYENV_ROOT/bin" ]]; then
	path_append "$PYENV_ROOT/bin"
fi
if [[ -e "$HOME/.cargo/env" ]]; then
	. "$HOME/.cargo/env"
fi

DATE=$(date +%Y-%m-%d)
export DATE

# Import API KEY
if [[ -f "$HOME/.config/.env" ]]; then
    export $(cat "$HOME/.config/.env" | xargs)
else
    echo "Warning: ~/.config/.env file not found" >&2
fi
