#!/usr/bin/env bash

if [[ -x $(which starship) ]]; then
	eval "$(starship init zsh)"
fi
if [[ -x $(which zoxide) ]]; then
	eval "$(zoxide init zsh)"
fi
if [[ -x $(which pyenv) ]]; then
	eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

# 启动 zellij (如果不在 zellij 会话中且终端支持)
if [[ -z "$ZELLIJ" ]]; then
  if [[ "$TERM" != "dumb" && "$TERM" != "linux" ]]; then
    if command -v zellij >/dev/null 2>&1; then
      zellij
    fi
  fi
fi
