# Tmux Toggle Pane

*Hide/Unhide the current pane in Tmux.*

## Installation
### Installation with TMux Plugin Manager (recommended)
Add plugin to the list of TPM plugins in `.tmux.conf`:
```bash
set -g @plugin 'tmux-plugins/tmux-toggle-pane'
```

Then, install the plugin by pressing `prefix + I`.

### Manual Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/K-JAX/tmux-toggle-pane.git ~/clone/path
   ```

2. Add the following line to your `.tmux.conf`:
   ```bash
    run-shell ~/clone/path/toggle-pane.tmux
    ```

## Usage
```bash
# navigate to the pane you want to toggle
tmux toggle-pane
# or here's an example with a key binding to capital T
bind-key T run-shell 'tmux toggle-pane'
```
