#!/usr/bin/env bash
#source "$(dirname "$0")/utils.sh"

restore() {
  tmux display-message -p "Restore pane: PROJECT_ROOT=$PROJECT_ROOT"
  tmux display-message -p "New line"
}
