#!/usr/bin/env bash
# source "$(dirname "$0")/utils.sh"

# eval "$(capture_layout)"

hide() {
  tmux display-message "Hide pane pane was called."
  # debug "Hiding pane ${origin} (${origin_id})"
}
