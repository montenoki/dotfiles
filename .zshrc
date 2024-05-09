#!/usr/bin/env bash

# Take tike to measure boot time
boot_time_start=$(gdate +%s%N 2>/dev/null || date +%s%N)

# First include of the environment.
# shellcheck source=/dev/null
source "$HOME/.config/zsh/environment.zsh"

# Download Znap, if it's not there yet.
[[ -r ~/.zsh/plugins/znap/znap.zsh ]] ||
	git clone --depth 1 -- \
		https://github.com/marlonrichert/zsh-snap.git ~/.zsh/plugins/znap
# shellcheck source=/dev/null
source "$HOME/.zsh/plugins/znap/znap.zsh" # Start Znap
# `znap source` starts plugins.
znap source marlonrichert/zsh-autocomplete

typeset -ga sources
sources+=("$ZSH_CONFIG/environment.zsh")
sources+=("$ZSH_CONFIG/options.zsh")
sources+=("$ZSH_CONFIG/init.zsh")
sources+=("$ZSH_CONFIG/aliases.zsh")
sources+=("$ZSH_CONFIG/autocmds.zsh")
sources+=("$ZSH_CONFIG/keybinds.zsh")

# try to include all sources
for file in "${sources[@]}"; do
	if [[ -e $file ]]; then
		source_include_time_start=$(gdate +%s%N 2>/dev/null || date +%s%N)
		# shellcheck source=/dev/null
		source "$file"
		source_include_duration=$((($(gdate +%s%N 2>/dev/null || date +%s%N) - source_include_time_start) / 1000000))
		echo "$source_include_duration ms runtime for $file"
	fi
done

[[ -r ~/.zsh/.zsh_history ]] ||
	touch ~/.zsh/.zsh_history
export HISTFILE=~/.zsh/.zsh_history
export HISTSIZE=1000
export SAVEHIST=100000

boot_time_end=$(gdate +%s%N 2>/dev/null || date +%s%N)
boot_time_duration=$(((boot_time_end - boot_time_start) / 1000000))
echo $boot_time_duration ms overall boot duration
