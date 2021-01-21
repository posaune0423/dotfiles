#!/bin/bash

# set tmux panes for ide

if [ "$#" -eq 0 ]; then
  tmux split-window -v
  tmux split-window -h
  tmux resize-pane -D 9
  tmux select-pane -t 1
else
  case $1 in
    1)
      tmux split-window -v
      tmux resize-pane -D 9
      tmux select-pane -D
      clear
      ;;
    2)
      tmux split-window -h
      tmux split-window -v
      tmux resize-pane -D 9
      tmux select-pane -t 1
      tmux split-window -v
      tmux select-pane -t 1
      clear
      ;;
    py)
      cd ~/Desktop/python
      tmux split-window -v
      tmux split-window -h
      tmux resize-pane -D 9
      tmux select-pane -t 1
      vi .
      clear
      ;;
    *)
      echo [ERROR] "$1" は設定されていない引数です。
      ;;
  esac
fi
