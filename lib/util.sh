#!/usr/bin/env bash

capture_layout() {
  local win_index pane_index pane_id
  win_index=$(tmux display-message -p '#{window_index}')
  pane_index=$(tmux display-message -p '#{pane_index}')
  pane_id=$(tmux display-message -p '#{pane_id}')

  echo "origin='${win_index}.${pane_index}'"
  echo "origin_id='${pane_id}'"
  echo "origin_left=$(tmux display-message -p '#{pane_left}')"
  echo "origin_top=$(tmux display-message -p '#{pane_top}')"
  echo "pane_width=$(tmux display-message -p '#{pane_width}')"
  echo "win_width=$(tmux display-message -p '#{window_width}')"
  echo "win_height=$(tmux display-message -p '#{window_height}')"
  echo "split_type=$(tmux show-option -gv "$HIDDEN_SPLIT_VAR")"
  echo "right_id=$(tmux show-option -gv "$HIDDEN_RIGHT_NEIGHBOR_VAR")"
  echo "width_percent=$(tmux show-option -gv "$HIDDEN_WIDTH_PCT_VAR")"
  echo "right_width_percent=$(tmux show-option -gv "$HIDDEN_RIGHT_WIDTH_PCT_VAR")"
  echo "left_id=$(tmux show-option -gv "$HIDDEN_LEFT_PANE_ID_VAR")"
  echo "left_width_percent=$(tmux show-option -gv "$HIDDEN_LEFT_WIDTH_PCT_VAR")"

  echo "current_win=$(tmux display-message -p '#{window_index}')"
  echo "default_target='${current_win}.0'"

}

debug() {
  tmux display-message "[toggle-pane] $*"
}
