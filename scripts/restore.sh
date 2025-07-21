#!/usr/bin/env bash

source "$TMUX_TP_ROOT/lib/util.sh"

restore() {
  # tmux display-message -p "restore() was called."
  tmux display-message -p "HIDDEN_LEFT_PANE_ID_VAR: $HIDDEN_LEFT_PANE_ID_VAR"

  #extracting -
  # $origin, $origin_id, $split_type, $right_id, $width_percent, $right_width_percent, $left_id, $left_width_percent, $current_win, $default_target
  eval "$(capture_layout)"
  tmux display-message "restore.sh: Retrieved $HIDDEN_LEFT_PANE_ID_VAR='${left_id}'"

  tmux display-message -p "split_type: $split_type"

  if [ "$split_type" = "vertical" ]; then
    if [ -n "$right_id" ]; then
      tmux join-pane -v -b -s "${HIDDEN_WINDOW}.0" -t "$right_id"
    elif [ -n "$left_id" ]; then
      tmux join-pane -v -s "${HIDDEN_WINDOW}.0" -t "$left_id"
    else
      tmux join-pane -v -s "${HIDDEN_WINDOW}.0" -t "$default_target"
    fi
  else
    if [ -n "$right_id" ]; then
      tmux display-message -p "Joining right pane: $right_id , from hidden window: ${HIDDEN_WINDOW}.0"
      tmux join-pane -h -b -s "${HIDDEN_WINDOW}.0" -t "$right_id"
    elif [ -n "$left_id" ]; then
      tmux display-message -p "Joining left pane: $left_id , from hidden window: ${HIDDEN_WINDOW}.0"
      tmux join-pane -h -s "${HIDDEN_WINDOW}.0" -t "$left_id"
    else
      tmux display-message -p "Joining default target: $default_target , from hidden window: ${HIDDEN_WINDOW}.0"
      tmux join-pane -h -s "${HIDDEN_WINDOW}.0" -t "$default_target"
    fi
  fi


  # new_pane_id=$(tmux display-message -p '#{pane_id}')
  # win_width=$(tmux display-message -p '#{window_width}')
  #
  # # resize the newly rejoined pane based on stored percentage
  # if [ -n "$width_percent" ]; then
  #   pane_width=$(awk -v w="$win_width" -v p="$width_percent" 'BEGIN { print int((w * p) / 100) }')
  #   tmux resize-pane -t "$new_pane_id" -x "$pane_width"
  # fi
  #
  # # resize the right neighbor pane if it exists
  # if [ -n "$right_id" ] && [ -n "$right_width_percent" ]; then
  #   right_width=$(awk -v w="$win_width" -v p="$right_width_percent" 'BEGIN { print int((w * p) / 100) }')
  #   tmux resize-pane -t "$right_id" -x "$right_width"
  # fi
  #
  # # resize the left neighbor pane if it exists
  # if [ -n "$left_id" ] && [ -n "$left_width_percent" ]; then
  #   left_width=$(awk -v w="$win_width" -v p="$left_width_percent" 'BEGIN { print int((w * p) / 100) }')
  #   tmux resize-pane -t "$left_id" -x "$left_width"
  # fi

  # clean up
  tmux kill-window -t "$HIDDEN_WINDOW"
  tmux set-option -gu "$HIDDEN_PANE_VAR"
  tmux set-option -gu "$HIDDEN_PANE_ID_VAR"
  tmux set-option -gu "$HIDDEN_SPLIT_VAR"
  tmux set-option -gu "$HIDDEN_RIGHT_NEIGHBOR_VAR"
  tmux set-option -gu "$HIDDEN_WIDTH_PCT_VAR"
  tmux set-option -gu "$HIDDEN_RIGHT_WIDTH_PCT_VAR"
  tmux set-option -gu "$HIDDEN_LEFT_PANE_ID_VAR"
  tmux set-option -gu "$HIDDEN_LEFT_WIDTH_PCT_VAR"

}
