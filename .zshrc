# Take tike to measure boot time
boot_time_start=$(gdate +%s%N 2>/dev/null || date +%s%N)

# First include of the environment.
source $HOME/.config/zsh/environment.zsh

typeset -ga sources
sources+="$ZSH_CONFIG/environment.zsh"
sources+="$ZSH_CONFIG/options.zsh"
sources+="$ZSH_CONFIG/init.zsh"
sources+="$ZSH_CONFIG/aliases.zsh"
sources+="$ZSH_CONFIG/autocmd.zsh"

# try to include all sources
foreach file (`echo $sources`)
  if [[ -a $file ]]; then
    # source_include_time_start=$(gdate +%s%N 2>/dev/null || date +%s%N)
    source $file
    # source_include_duration=$((($(gdate +%s%N 2>/dev/null || date +%s%N) - $source_include_time_start)/1000000))
    # echo $source_include_duration ms runtime for $file
  fi
end

boot_time_end=$(gdate +%s%N 2>/dev/null || date +%s%N)
boot_time_duration=$((($boot_time_end - $boot_time_start) / 1000000))
echo $boot_time_duration ms overall boot duration
