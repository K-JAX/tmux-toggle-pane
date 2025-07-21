#!/usr/bin/env bash

source "$TMUX_TP_ROOT/lib/util.sh"


hide() {
  # tmux display-message -p "hide() was called."
  
  # extracting -
  # $origin, $origin_id, $origin_left, $origin_top, $pane_width, $win_width, $win_height
  eval "$(capture_layout)"


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
  tmux display-message -p "left_info: '$left_info'"

  # left_id=$(echo "$left_info" | awk '{print $1}')
  left_id=$(awk '{print $1}' <<< "$left_info")

  tmux display-message -p "hide.sh: Calculated left_id='$left_id'"
  left_width=$(echo "$left_info" | awk '{print $2}')
  left_width_percent=$(awk -v w="$win_width" -v p="$left_width" 'BEGIN { printf "%.0f", (p/w) * 100 }')
  tmux display-message -p "hide.sh: Calculated left_id='$left_id'"
  tmux display-message -p "hide.sh: Setting $HIDDEN_LEFT_PANE_ID_VAR to '$left_id'"

  tmux break-pane -d -n "$HIDDEN_WINDOW"

  tmux display-message -p "origin: $origin"

  tmux set-option -g "$HIDDEN_PANE_VAR" "$origin"
  tmux set-option -g "$HIDDEN_PANE_ID_VAR" "$origin_id"
  tmux set-option -g "$HIDDEN_SPLIT_VAR" "$split_type"
  tmux set-option -g "$HIDDEN_RIGHT_NEIGHBOR_VAR" "$right_id"
  tmux set-option -g "$HIDDEN_WIDTH_PCT_VAR" "$width_percent"
  tmux set-option -g "$HIDDEN_RIGHT_WIDTH_PCT_VAR" "$right_width_percent"
  tmux set-option -g "$HIDDEN_LEFT_PANE_ID_VAR" "$left_id"
  tmux set-option -g "$HIDDEN_LEFT_WIDTH_PCT_VAR" "$left_width_percent"

  tmux display-message -p "Retrieved $HIDDEN_LEFT_PANE_ID_VAR: '$(tmux show-option -gv "$HIDDEN_LEFT_PANE_ID_VAR")'"
}
