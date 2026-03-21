# ~/.config/zsh/tools.zsh
# 开发工具初始化
# 依赖: environment.zsh

# -- Homebrew ------------------------------------------------------
if [[ "$OSTYPE" == darwin* ]]; then
    [[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# -- NVM (懒加载) --------------------------------------------------
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
    _nvm_load() {
        unset -f nvm node npm npx yarn pnpm corepack _nvm_load
        source "$NVM_DIR/nvm.sh"
        [[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"
    }
    nvm()      { _nvm_load; nvm      "$@"; }
    node()     { _nvm_load; node     "$@"; }
    npm()      { _nvm_load; npm      "$@"; }
    npx()      { _nvm_load; npx      "$@"; }
    yarn()     { _nvm_load; yarn     "$@"; }
    pnpm()     { _nvm_load; pnpm     "$@"; }
    corepack() { _nvm_load; corepack "$@"; }
    command_not_found_handler() {
        if (( $+functions[_nvm_load] )); then
            _nvm_load
            if (( $+commands[$1] )); then
                "$@"; return $?
            fi
        fi
        echo "zsh: command not found: $1" >&2
        return 127
    }
fi

# -- Pyenv ---------------------------------------------------------
if (( $+commands[pyenv] )); then
    eval "$(pyenv init -)"
    (( $+commands[pyenv-virtualenv-init] )) && eval "$(pyenv virtualenv-init -)"
fi

# -- Starship -----------------------------------------------------
(( $+commands[starship] )) && eval "$(starship init zsh)"

# -- Zoxide -------------------------------------------------------
(( $+commands[zoxide] )) && eval "$(zoxide init zsh)"
