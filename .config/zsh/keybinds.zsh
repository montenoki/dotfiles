#!/usr/bin/env bash

bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

bindkey "^[[3~" delete-char

bindkey "^[[1;C" forward-word
bindkey "^[[1;D" backward-word
