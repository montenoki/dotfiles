#!/usr/bin/env bash

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

export ZSH_CONFIG="$XDG_CONFIG_HOME/zsh"
export ZSH_CACHE="$XDG_CACHE_HOME/zsh"
export PYENV_ROOT="$HOME/.pyenv"

[ -d "$ZSH_CACHE" ] || mkdir -p "$ZSH_CACHE"

path_append() {
    if [ -d "$1" ]; then
        case ":$PATH:" in
        *:"$1":*) ;;
        *)
            export PATH="${PATH:+$PATH:}$1"
            ;;
        esac
    fi
}

path_prepend() {
    if [ -d "$1" ]; then
        case ":$PATH:" in
        *:"$1":*) ;;
        *)
            export PATH="$1${PATH:+:$PATH}"
            ;;
        esac
    fi
}

path_append "/usr/local/sbin"
path_append "/snap/bin"

if [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

if [[ -d "$PYENV_ROOT/bin" ]]; then
    path_prepend "$PYENV_ROOT/bin"
fi

if [[ -e "$HOME/.cargo/env" ]]; then
    . "$HOME/.cargo/env"
fi

path_prepend "$HOME/.local/sbin"
path_prepend "$HOME/.local/bin"

DATE=$(date +%Y-%m-%d)
export DATE

if [[ -f "$HOME/.config/.env" ]]; then
    export $(cat "$HOME/.config/.env" | xargs)
else
    echo "Warning: ~/.config/.env file not found" >&2
fi

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"
