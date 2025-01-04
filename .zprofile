# 如果是MacOS系统（darwin）则初始化Homebrew环境
if [[ "$OSTYPE" == "darwin"* ]]; then
	# 执行brew shellenv命令来设置Homebrew的环境变量
	# 包括PATH、MANPATH和其他Homebrew所需的环境变量
	eval "$(/opt/homebrew/bin/brew shellenv)"
fi
