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

# 遍历并加载所有配置文件
for file in "${sources[@]}"; do
	if [[ -e $file ]]; then
		# shellcheck source=/dev/null
		source "$file"
	fi
done

# 配置命令历史记录
[[ -r ~/.zsh/.zsh_history ]] ||
	touch ~/.zsh/.zsh_history
export HISTFILE=~/.zsh/.zsh_history    # 历史文件路径
export HISTSIZE=1000                   # 当前会话历史记录数
export SAVEHIST=100000                 # 历史文件记录数
