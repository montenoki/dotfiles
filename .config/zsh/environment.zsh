# ============================================================================
# XDG 基础目录规范
# ============================================================================
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

# ============================================================================
# Shell 配置目录
# ============================================================================
export ZSH_CONFIG="$XDG_CONFIG_HOME/zsh"
export ZSH_CACHE="$XDG_CACHE_HOME/zsh"
export PYENV_ROOT="$HOME/.pyenv"

# 确保缓存目录存在
[ -d "$ZSH_CACHE" ] || mkdir -p "$ZSH_CACHE"

# ============================================================================
# PATH 管理函数
# ============================================================================

# 添加目录到 PATH（支持前置或后置）
# 用法: path_add [--prepend|--append] <directory>
path_add() {
    local mode="append"
    local dir=""
    
    # 解析参数
    while [ $# -gt 0 ]; do
        case "$1" in
            --prepend)
                mode="prepend"
                shift
                ;;
            --append)
                mode="append"
                shift
                ;;
            *)
                dir="$1"
                shift
                ;;
        esac
    done
    
    # 检查目录是否存在
    if [ ! -d "$dir" ]; then
        return 1
    fi
    
    # 检查目录是否已在 PATH 中
    case ":$PATH:" in
        *:"$dir":*)
            return 0
            ;;
    esac
    
    # 添加到 PATH
    if [ "$mode" = "prepend" ]; then
        export PATH="$dir${PATH:+:$PATH}"
    else
        export PATH="${PATH:+$PATH:}$dir"
    fi
}

# ============================================================================
# 系统路径配置
# ============================================================================
path_add --append "/usr/local/sbin"
path_add --append "/snap/bin"

# ============================================================================
# 开发工具初始化
# ============================================================================

# Homebrew（Linux）
if [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Pyenv
if [[ -d "$PYENV_ROOT/bin" ]]; then
    path_add --prepend "$PYENV_ROOT/bin"
fi

# Rust/Cargo
if [[ -e "$HOME/.cargo/env" ]]; then
    . "$HOME/.cargo/env"
fi

# Node Version Manager (nvm)
export NVM_DIR="$HOME/.config/nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
    . "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
fi

# OpenCode
path_add --prepend "$HOME/.opencode/bin"

# 用户本地路径（优先级最高）
path_add --prepend "$HOME/.local/sbin"
path_add --prepend "$HOME/.local/bin"

# ============================================================================
# 环境变量
# ============================================================================

# 当前日期
DATE=$(date +%Y-%m-%d)
export DATE

# ============================================================================
# 加载本地环境配置文件
# ============================================================================
if [[ -f "$HOME/.config/.env" ]]; then
    # 安全地加载 .env 文件
    # 跳过空行和注释行，正确处理键值对
    while IFS='=' read -r key value; do
        # 跳过空行
        [[ -z "$key" ]] && continue
        # 跳过注释行
        [[ "$key" =~ ^[[:space:]]*# ]] && continue
        # 移除前后空格
        key=$(echo "$key" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
        value=$(echo "$value" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
        # 移除值两端的引号（如果有）
        value=$(echo "$value" | sed 's/^["'\'']\(.*\)["'\'']$/\1/')
        # 导出变量
        [[ -n "$key" ]] && export "$key=$value"
    done < "$HOME/.config/.env"
else
    echo "警告: 未找到 ~/.config/.env 文件" >&2
fi

# ============================================================================
# 输入法配置（Fcitx）
# ============================================================================
# 仅在 Fcitx 可用时设置输入法环境变量
if command -v fcitx5 >/dev/null 2>&1 || command -v fcitx >/dev/null 2>&1; then
    export GTK_IM_MODULE=fcitx
    export QT_IM_MODULE=fcitx
    export XMODIFIERS="@im=fcitx"
fi
