#!/bin/bash

SESSION="train"

if tmux has-session -t "$SESSION" 2>/dev/null; then
  tmux attach -t "$SESSION"
  exit 0
fi

tmux new-session -d -s "$SESSION" -n datasets

tmux new-window -t "$SESSION:" -n experiments

tmux new-window -t "$SESSION:" -n datacreate

tmux new-window -t "$SESSION:" -n training

tmux new-window -t "$SESSION:" -n tensorboard

tmux new-window -t "$SESSION:" -n mltop
tmux send-keys -t "$SESSION:mltop" 'mltop' C-m

tmux select-window -t "$SESSION:0"

tmux attach-session -t "$SESSION"
