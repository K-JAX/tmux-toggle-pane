#!/usr/bin/env bash

capture_layout() {
  local win_index pane_index pane_id
  win_index=$(tmux display-message -p '#{window_index}')
  pane_index=$(tmux display-message -p '#{pane_index}')
  pane_id=$(tmux display-message -p '#{pane_id}')

  echo "origin='${win_index}.${pane_index}'"
  echo "origin_id='${pane_id}'"
}

debug() {
  tmux display-message "[toggle-pane] $*"
}
