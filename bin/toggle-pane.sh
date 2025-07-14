#!/usr/bin/env bash

# configurable constraints
HIDDEN_WINDOW="_hidden_pane"
HIDDEN_PANE_VAR="@hidden_pane_origin"
HIDDEN_PANE_ID_VAR="@hidden_pane_id"
HIDDEN_SPLIT_VAR="@hidden_pane_split_type"
HIDDEN_RIGHT_NEIGHBOR_VAR="@hidden_pane_right_neighbor"
HIDDEN_WIDTH_PCT_VAR="@hidden_pane_width_pct"
HIDDEN_RIGHT_WIDTH_PCT_VAR="@hidden_right_pane_width_pct"
HIDDEN_LEFT_PANE_ID_VAR="@hidden_left_pane_id"
HIDDEN_LEFT_WIDTH_PCT_VAR="@hidden_left_pane_width_pct"

# check if pane is already hidden
if tmux list-windows | grep -q "$HIDDEN_WINDOW"; then
  
  # restore the hidden pane
  origin=$(tmux show-option -gv "$HIDDEN_PANE_VAR")
  origin_id=$(tmux show-option -gv "$HIDDEN_PANE_ID_VAR")
  split_type=$(tmux show-option -gv "$HIDDEN_SPLIT_VAR")
  right_id=$(tmux show-option -gv "$HIDDEN_RIGHT_NEIGHBOR_VAR")
  width_percent=$(tmux show-option -gv "$HIDDEN_WIDTH_PCT_VAR")
  right_width_percent=$(tmux show-option -gv "$HIDDEN_RIGHT_WIDTH_PCT_VAR")
  left_id=$(tmux show-option -gv "$HIDDEN_LEFT_PANE_ID_VAR")
  left_width_percent=$(tmux show-option -gv "$HIDDEN_LEFT_WIDTH_PCT_VAR")

  current_win=$(tmux display-message -p '#{window_index}')
  default_target="${current_win}.0"

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
      tmux join-pane -h -b -s "${HIDDEN_WINDOW}.0" -t "$right_id"
    elif [ -n "$left_id" ]; then
      tmux join-pane -h -s "${HIDDEN_WINDOW}.0" -t "$left_id"
    else
      tmux join-pane -h -s "${HIDDEN_WINDOW}.0" -t "$default_target"
    fi
  fi


  new_pane_id=$(tmux display-message -p '#{pane_id}')
  win_width=$(tmux display-message -p '#{window_width}')

  # resize the newly rejoined pane based on stored percentage
  if [ -n "$width_percent" ]; then
    pane_width=$(awk -v w="$win_width" -v p="$width_percent" 'BEGIN { print int((w * p) / 100) }')
    tmux resize-pane -t "$new_pane_id" -x "$pane_width"
  fi

  # resize the right neighbor pane if it exists
  if [ -n "$right_id" ] && [ -n "$right_width_percent" ]; then
    right_width=$(awk -v w="$win_width" -v p="$right_width_percent" 'BEGIN { print int((w * p) / 100) }')
    tmux resize-pane -t "$right_id" -x "$right_width"
  fi

  # resize the left neighbor pane if it exists
  if [ -n "$left_id" ] && [ -n "$left_width_percent" ]; then
    left_width=$(awk -v w="$win_width" -v p="$left_width_percent" 'BEGIN { print int((w * p) / 100) }')
    tmux resize-pane -t "$left_id" -x "$left_width"
  fi

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

else
  # hide the current pane

  origin_pane="$(tmux display-message -p '#{window_index}.#{pane_index}')"
  origin_id="$(tmux display-message -p '#{pane_id}')"
  origin_left=$(tmux display-message -p '#{pane_left}')
  origin_top=$(tmux display-message -p '#{pane_top}')
  pane_width=$(tmux display-message -p '#{pane_width}')
  win_width=$(tmux display-message -p '#{window_width}')

  if [ "$pane_width" -lt "$win_width" ]; then
    split_type="horizontal"
  else
    split_type="vertical"
  fi

  width_percent=$(awk -v p="$pane_width" -v w="$win_width" 'BEGIN { printf "%.0f", (p/w) * 100 }')

  right_info=$(tmux list-panes -F '#{pane_id} #{pane_left} #{pane_top} #{pane_width}' | awk -v self="$origin_id" -v left="$origin_left" -v top="$origin_top" '
    $1 != self && $3 == top && $2 > left {
      print $1, $4; exit
    }')
  right_id=$(echo "$right_info" | awk '{print $1}')
  right_width=$(echo "$right_info" | awk '{print $2}')
  right_width_percent=$(awk -v w="$win_width" -v p="$right_width" 'BEGIN { printf "%.0f", (p/w) * 100 }')

  left_info=$(tmux list-panes -F '#{pane_id} #{pane_left} #{pane_top} #{pane_width}' | awk -v self="$origin_id" -v left="$origin_left" -v top="$origin_top" '
    $1 != self && $3 == top && $2 < left {
      max_left = -1
      if ($2 > max_left) {
        max_left = $2
        id = $1
        width = $4
      }
    }
    END { if (id != "") print id, width }
  ')
  left_id=$(echo "$left_info" | awk '{print $1}')
  left_width=$(echo "$left_info" | awk '{print $2}')
  left_width_percent=$(awk -v w="$win_width" -v p="$left_width" 'BEGIN { printf "%.0f", (p/w) * 100 }')

  tmux break-pane -d -n "$HIDDEN_WINDOW"

  tmux set-option -g "$HIDDEN_PANE_VAR" "$origin_pane"
  tmux set-option -g "$HIDDEN_PANE_ID_VAR" "$origin_id"
  tmux set-option -g "$HIDDEN_SPLIT_VAR" "$split_type"
  tmux set-option -g "$HIDDEN_RIGHT_NEIGHBOR_VAR" "$right_id"
  tmux set-option -g "$HIDDEN_WIDTH_PCT_VAR" "$width_percent"
  tmux set-option -g "$HIDDEN_RIGHT_WIDTH_PCT_VAR" "$right_width_percent"
  tmux set-option -g "$HIDDEN_LEFT_PANE_ID_VAR" "$left_id"
  tmux set-option -g "$HIDDEN_LEFT_WIDTH_PCT_VAR" "$left_width_percent"
fi

