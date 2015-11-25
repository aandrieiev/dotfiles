#!/bin/sh

program="`tmux display -p '#{pane_current_command}'`"

if [[ $program == "nvim" ]]; then
  # let nvim handle it
  tmux send-keys 'C-\' 'C-n' 'C-w' $1
elif [[ $program == "vim" ]]; then
  # let vim handle it
  tmux send-keys 'Escape' 'C-w' $1
else
  # do the normal tmux thing
  case $1 in
    j) tmux select-pane -D ;;
    k) tmux select-pane -U ;;
    h) tmux select-pane -L ;;
    l) tmux select-pane -R ;;
  esac
fi
