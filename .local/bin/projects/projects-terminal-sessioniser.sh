#!/bin/bash
# the idea is that the tmux scripts start the current project tmux server
# this script launches the fzf picker for the new project
# and starts all the processors
# and then kills the old node processes and stop docker in the old project

CURRENT=$(tmux -L alacritty display-message -p '#S')
PROJECTS_PATH=/home/matt/projects
CURRENT_PATH="$PROJECTS_PATH/$CURRENT"
TMUX_PROJECTS_SCRIPT=~/.local/bin/projects/run-project.sh
TMUX_PROJECTS_ENV=~/.local/bin/projects/env

# pipe all project scripts into fzf after removing .sh extension to clean output
NEW=$(ls "$TMUX_PROJECTS_ENV" | sed 's/\.sh$//' | fzf --border --border-label=" Project picker ")

# no new project found (might hit escp on fzf) then don't do anything
[ -z "$NEW" ] && exit 0

if tmux -L kitty ls 2>&1 | grep -qiE 'error connecting to|no server'; then
    # we run this in one cmd so we don't create any race conditions & notice how we start tmux in detached and then attach so that when nvim closes it doesn't close the terminal/tmux
    tmux run-shell "kitty --hold --start-as fullscreen sh -c 'tmux -L kitty new-session -d -s $NEW -n neovim -c $PROJECTS_PATH/$NEW nvim . \; attach -t $NEW' > /dev/null 2>&1 &"
elif tmux -L kitty has-session -t "$NEW" 2>/dev/null; then
    tmux -L kitty switch-client -t "$NEW"
else
    tmux -L kitty new-session -d -s "$NEW" -n "neovim"
    tmux -L kitty send-keys -t "$NEW":neovim "cd $PROJECTS_PATH/$NEW && nvim ."  C-m
    tmux -L kitty switch-client -t "$NEW"
fi

if [[ -d "$CURRENT_PATH" ]]; then
    pkill -f "node.*$CURRENT_PATH" ;
    cd "$CURRENT_PATH" &&
    docker compose stop
fi

# shellcheck source=/dev/null
source $TMUX_PROJECTS_ENV/"$NEW.sh"
bash $TMUX_PROJECTS_SCRIPT

