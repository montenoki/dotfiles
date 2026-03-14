# ~/.config/zsh/.zshrc
# 交互式 Shell 配置

# 测速（按需：ZSH_PROFILE=1 zsh -i -c exit）
[[ -n "$ZSH_PROFILE" ]] && zmodload zsh/zprof

source "$ZDOTDIR/environment.zsh"
source "$ZDOTDIR/tools.zsh"

# ── Znap 插件管理器 ──────────────────────────────────────────────
ZNAP_HOME="$HOME/.zsh/plugins/znap"
[[ -r "$ZNAP_HOME/znap.zsh" ]] ||
    git clone --depth 1 https://github.com/marlonrichert/zsh-snap.git "$ZNAP_HOME"
source "$ZNAP_HOME/znap.zsh"

znap source marlonrichert/zsh-autocomplete

# ── 模块化配置 ───────────────────────────────────────────────────
for config in options aliases keybinds; do
    source "$ZDOTDIR/${config}.zsh"
done

[[ -n "$ZSH_PROFILE" ]] && zprof
