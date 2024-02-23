# XDG Base Directory Specification
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export ZSH_CONFIG="$XDG_CONFIG_HOME/zsh"
export ZSH_CACHE="$XDG_CACHE_HOME/zsh"
export PYENV_ROOT="$HOME/.pyenv"
mkdir -p $ZSH_CACHE

# executable search path
path_append () {
  # Add path to $PATH if path not exist.
  case ":$PATH:" in
    *:"$1":*)
      ;;
    *)
      export PATH="${PATH:+$PATH:}$1"
      ;;
  esac
}
path_append "/usr/local/sbin"
path_append "$HOME/.local/bin"
path_append "$HOME/.local/sbin"

if [[ -d "$PYENV_ROOT/bin" ]]; then
  path_append "$PYENV_ROOT/bin"
fi

if [[ -d "$HOME/.cargo/env" ]]; then
  . "$HOME/.cargo/env"
fi

export DATE=$(date +%Y-%m-%d)
