#!/usr/bin/env bash

# 开始计时，测量启动时间
boot_time_start=$(gdate +%s%N 2>/dev/null || date +%s%N)

# 首先加载环境配置
# shellcheck source=/dev/null
source "$HOME/.config/zsh/environment.zsh"

# 如果没有安装Znap插件管理器，则下载安装
[[ -r ~/.zsh/plugins/znap/znap.zsh ]] ||
	git clone --depth 1 -- \
		https://github.com/marlonrichert/zsh-snap.git ~/.zsh/plugins/znap
# shellcheck source=/dev/null
source "$HOME/.zsh/plugins/znap/znap.zsh" # 启动Znap
# 加载自动补全插件
znap source marlonrichert/zsh-autocomplete

# 定义配置文件数组
typeset -ga sources
sources+=("$ZSH_CONFIG/environment.zsh")  # 环境变量配置
sources+=("$ZSH_CONFIG/options.zsh")      # zsh选项配置
sources+=("$ZSH_CONFIG/init.zsh")         # 初始化配置
sources+=("$ZSH_CONFIG/aliases.zsh")      # 别名配置
sources+=("$ZSH_CONFIG/autocmds.zsh")     # 自动命令配置
sources+=("$ZSH_CONFIG/keybinds.zsh")     # 快捷键配置

# 遍历并加载所有配置文件，同时记录每个文件的加载时间
for file in "${sources[@]}"; do
	if [[ -e $file ]]; then
		source_include_time_start=$(gdate +%s%N 2>/dev/null || date +%s%N)
		# shellcheck source=/dev/null
		source "$file"
		source_include_duration=$((($(gdate +%s%N 2>/dev/null || date +%s%N) - source_include_time_start) / 1000000))
		echo "$source_include_duration ms runtime for $file"
	fi
done

# 配置命令历史记录
[[ -r ~/.zsh/.zsh_history ]] ||
	touch ~/.zsh/.zsh_history
export HISTFILE=~/.zsh/.zsh_history    # 历史文件路径
export HISTSIZE=1000                   # 当前会话历史记录数
export SAVEHIST=100000                 # 历史文件记录数

# 计算并显示总启动时间
boot_time_end=$(gdate +%s%N 2>/dev/null || date +%s%N)
boot_time_duration=$(((boot_time_end - boot_time_start) / 1000000))
echo $boot_time_duration ms overall boot duration

# 启动 zellij (如果不在 zellij 会话中且终端支持)
if [[ -z "$ZELLIJ" ]]; then
  if [[ "$TERM" != "dumb" && "$TERM" != "linux" ]]; then
    if command -v zellij >/dev/null 2>&1; then
      zellij
    fi
  fi
fi
