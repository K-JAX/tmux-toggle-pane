#!/usr/bin/env bash

# get $PROJECT_ROOT and other important path variables
source "$(dirname "${BASH_SOURCE[0]}")/../lib/paths.sh"

# tmux display-message -p "trying to run the script to toggle pane visiblity."

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

source "$TMUX_TP_ROOT/scripts/restore.sh"
source "$TMUX_TP_ROOT/scripts/hide.sh"

# check if pane is already hidden
if tmux list-windows | grep -q "$HIDDEN_WINDOW"; then
  # pane is hidden, so we restore it
#  tmux display-message "pane is hidden, restoring it."
  restore
else
  # hide the current pane
#  tmux display-message "pane is visible, hiding it."
  hide
fi

