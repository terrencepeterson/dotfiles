#!/bin/bash
source /home/matt/.shell.d/00-helper-functions.sh

PROJECTS_PATH="$HOME/projects"
declare -a paths=(
    "$HOME/.shell.d"
    "$HOME/.local/bin"
    "$HOME/.config/nvim"
    "$HOME/.config/tmux"
    "$HOME/.config/alacritty"
    "$HOME/.config/kitty"
)

NO_PROJECT_PATHS=$(printf "%s%s" $'\n' "$(implode paths $'\n')")
SESSION_NAME="$(fd --type d --hidden --max-depth 5 '\.git$' ~/projects | sed 's|.*/projects/\(.*\)/.git.*|\1|') $NO_PROJECT_PATHS"
SESSION_NAME=$(echo "$SESSION_NAME" | fzf --border --border-label=" 🚀 Project picker ")

NVIM_PATH="$PROJECTS_PATH/$SESSION_NAME"
if [[ -d "$SESSION_NAME" ]]; then # this is for the dir's that aren't in ~/projects
    NVIM_PATH="$SESSION_NAME"
    SESSION_NAME="${SESSION_NAME##*/}-conf"
fi

# tmux converts "." in session names to _ so we do it before hand so we can keep the correct session name
# breaks the send-keys and switch client in the else clause below if not
SESSION_NAME=${SESSION_NAME//./_}

# no new project found (might hit escp on fzf) then don't do anything
[ -z "$SESSION_NAME" ] && exit 0

if tmux -L kitty ls 2>&1 | grep -qiE 'error connecting to|no server'; then
    tmux -L kitty new-session -s "$SESSION_NAME" -n neovim -c "$NVIM_PATH" nvim .
elif tmux -L kitty has-session -t "$SESSION_NAME" 2>/dev/null; then
    tmux -L kitty switch-client -t "$SESSION_NAME"
else
    tmux -L kitty new-session -d -s "$SESSION_NAME" -n "neovim"
    tmux -L kitty send-keys -t "$SESSION_NAME":neovim "cd $NVIM_PATH && nvim ." C-m
    tmux -L kitty switch-client -t "$SESSION_NAME"
fi

