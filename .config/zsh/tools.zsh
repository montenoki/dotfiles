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

# -- Claude Code provider switching --------------------------------
use-deepseek() {
    if [[ -z "$OPENROUTER_API_KEY" ]]; then
        print -u2 "use-deepseek: OPENROUTER_API_KEY is not set"
        return 1
    fi

    local config_dir="$XDG_CONFIG_HOME/claude-code"
    local override_file="$config_dir/provider.override.env"

    mkdir -p "$config_dir" || return 1

    cat > "$override_file" <<EOF
ANTHROPIC_BASE_URL=https://openrouter.ai/api
ANTHROPIC_AUTH_TOKEN=${OPENROUTER_API_KEY}
ANTHROPIC_API_KEY=
ANTHROPIC_MODEL=deepseek/deepseek-v4-pro
ANTHROPIC_DEFAULT_SONNET_MODEL=deepseek/deepseek-v4-pro
ANTHROPIC_DEFAULT_OPUS_MODEL=deepseek/deepseek-v4-pro
ANTHROPIC_DEFAULT_HAIKU_MODEL=deepseek/deepseek-v4-flash
CLAUDE_CODE_SUBAGENT_MODEL=deepseek/deepseek-v4-flash
CLAUDE_CODE_PROVIDER=openrouter-deepseek
EOF

    chmod 600 "$override_file" || return 1

    export ANTHROPIC_BASE_URL="https://openrouter.ai/api"
    export ANTHROPIC_AUTH_TOKEN="$OPENROUTER_API_KEY"
    export ANTHROPIC_API_KEY=""
    export ANTHROPIC_MODEL="deepseek/deepseek-v4-pro"
    export ANTHROPIC_DEFAULT_OPUS_MODEL="deepseek/deepseek-v4-pro"
    export ANTHROPIC_DEFAULT_SONNET_MODEL="deepseek/deepseek-v4-pro"
    export ANTHROPIC_DEFAULT_HAIKU_MODEL="deepseek/deepseek-v4-flash"
    export CLAUDE_CODE_SUBAGENT_MODEL="deepseek/deepseek-v4-flash"
    export CLAUDE_CODE_PROVIDER="openrouter-deepseek"

    print "Switched to DeepSeek via OpenRouter. Reload or restart VSCode."
}

use-claude() {
    local config_dir="$XDG_CONFIG_HOME/claude-code"
    local override_file="$config_dir/provider.override.env"

    rm -f "$override_file"

    unset ANTHROPIC_BASE_URL
    unset ANTHROPIC_AUTH_TOKEN
    unset ANTHROPIC_MODEL
    unset ANTHROPIC_DEFAULT_SONNET_MODEL
    unset ANTHROPIC_DEFAULT_OPUS_MODEL
    unset ANTHROPIC_DEFAULT_HAIKU_MODEL
    unset CLAUDE_CODE_SUBAGENT_MODEL
    unset CLAUDE_CODE_PROVIDER

    _load_dotenv "$XDG_CONFIG_HOME/.env"

    print "Restored default Claude. Reload or restart VSCode."
}

cc-status() {
    local override_file="$XDG_CONFIG_HOME/claude-code/provider.override.env"

    if [[ -f "$override_file" ]]; then
        print "Provider: openrouter-deepseek (override active)"
    else
        print "Provider: default (official Claude)"
    fi

    print "Base URL: ${ANTHROPIC_BASE_URL:-official Anthropic}"
    print "Model: ${ANTHROPIC_MODEL:-default}"
    print "Override file: ${XDG_CONFIG_HOME}/claude-code/provider.override.env [$([[ -f "$override_file" ]] && print present || print absent)]"
}
