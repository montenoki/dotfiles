# ~/.config/zsh/environment.zsh
# 环境变量 & PATH

# -- XDG 基础目录 -------------------------------------------------
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

export ZSH_CACHE="$XDG_CACHE_HOME/zsh"
[[ -d "$ZSH_CACHE" ]] || mkdir -p "$ZSH_CACHE"

# -- 编辑器 --------------------------------------------------------
export EDITOR="nvim"
export VISUAL="$EDITOR"

# -- 开发工具根目录 ------------------------------------------------
export PYENV_ROOT="$HOME/.pyenv"
export NVM_DIR="$XDG_CONFIG_HOME/nvm"

# -- PATH 管理 -----------------------------------------------------
typeset -gU path  # -U = unique，自动去重

# 前置路径（优先级从低到高，后添加的在最前）
typeset -a prepend_dirs=(
    "$PYENV_ROOT/bin"
    "$HOME/.opencode/bin"
    "$HOME/.local/sbin"
    "$HOME/.local/bin"
)

# 后置路径
typeset -a append_dirs=(
    "/usr/local/sbin"
    "/snap/bin"
)

typeset d
for d in $prepend_dirs; do
    [[ -d "$d" ]] && path=("$d" $path)
done
for d in $append_dirs; do
    [[ -d "$d" ]] && path+=("$d")
done

# -- 加载 .env 文件 ------------------------------------------------
_load_dotenv() {
    local envfile="$1"
    [[ -f "$envfile" ]] || return

    local line key value
    while IFS= read -r line || [[ -n "$line" ]]; do
        # 去前后空白
        line="${line## }"
        line="${line%% }"

        # 跳过空行和注释
        [[ -z "$line" || "$line" == \#* ]] && continue

        # 分割 key=value（只在第一个 = 处分割）
        key="${line%%=*}"
        value="${line#*=}"

        # 去 key/value 前后空白
        key="${key## }" ; key="${key%% }"
        value="${value## }" ; value="${value%% }"

        # 去引号（单引号或双引号）
        if [[ "$value" == \"*\" || "$value" == \'*\' ]]; then
            value="${value:1:-1}"
        fi

        [[ -n "$key" ]] && export "$key=$value"
    done < "$envfile"
}

_load_dotenv "$XDG_CONFIG_HOME/.env"

# -- Rust (Cargo) --------------------------------------------------
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

# -- 输入法（Fcitx） ----------------------------------------------
if (( $+commands[fcitx5] || $+commands[fcitx] )); then
    export GTK_IM_MODULE=fcitx
    export QT_IM_MODULE=fcitx
    export XMODIFIERS="@im=fcitx"
fi
