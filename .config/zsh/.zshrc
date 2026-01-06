# ============================================================================
# 交互式 Shell 配置
# ============================================================================

# 确保环境变量已加载（非登录 shell）
[[ -z "$XDG_CONFIG_HOME" ]] && source "$ZDOTDIR/environment.zsh"

# ============================================================================
# 插件管理器 (Znap)
# ============================================================================
ZNAP_HOME="$HOME/.zsh/plugins/znap"
[[ -r "$ZNAP_HOME/znap.zsh" ]] ||
    git clone --depth 1 https://github.com/marlonrichert/zsh-snap.git "$ZNAP_HOME"
source "$ZNAP_HOME/znap.zsh"

znap source marlonrichert/zsh-autocomplete

# ============================================================================
# 加载模块化配置
# ============================================================================
for config in options aliases keybinds; do
    source "$ZDOTDIR/${config}.zsh"
done

# ============================================================================
# 工具初始化
# ============================================================================
command -v starship &>/dev/null && eval "$(starship init zsh)"
command -v zoxide &>/dev/null && eval "$(zoxide init zsh)"
