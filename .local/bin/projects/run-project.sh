#!/bin/bash

tmux has-session -t "$SESH" 2>/dev/null

if [ $? != 0 ]; then
    tmux new-session -d -s "$SESH" -n "ssh-local"

    # Hooks
    tmux set-hook -t "$SESH" session-closed "run-shell 'cd $COMPOSE_DIR && docker compose down >> $LOG 2>&1 || tmux display-message \"docker compose down failed for $SESH\"'"

    tmux send-keys -t "$SESH":ssh-local "cd $PROJECT_DIR" C-m
    tmux send-keys -t "$SESH":ssh-local "dc up -d" C-m

    tmux new-window -t "$SESH" -n "styles"

    tmux new-window -t "$SESH" -n "cmd"
    tmux send-keys -t "$SESH":cmd "cd $PROJECT_DIR" C-m
    tmux send-keys -t "$SESH":cmd "site -e d $ALIAS" C-m
    tmux send-keys -t "$SESH":cmd "site -e d -a $ALIAS" C-m
    tmux send-keys -t "$SESH":cmd "ff-harv" C-m
    tmux send-keys -t "$SESH":cmd "ff-taskm" C-m
    tmux send-keys -t "$SESH":cmd "site -r $ALIAS" C-m

    tmux new-window -t "$SESH" -n "ssh-staging"
    tmux send-keys -t "$SESH":ssh-staging "cd $PROJECT_DIR && ssh $SSH_STAGING" C-m

    tmux new-window -t "$SESH" -n "ssh-prod"
    tmux send-keys -t "$SESH":ssh-prod "cd $PROJECT_DIR && ssh $SSH_PROD" C-m

    tmux select-window -t "$SESH":cmd
fi

# This runs everytime the script is called but it's purpose is to run the dc start on attach - there are no proper attach hooks for tmux
# it doesn't matter that it runs after dc up -d
tmux send-keys -t "$SESH":ssh-local "cd $COMPOSE_DIR && docker compose start && docker compose exec -it -u app $DOCKER_MAIN_CONTAINER_NAME zsh" C-m
tmux send-keys -t "$SESH":styles "cd $STYLES_DIR && $STYLES_CMD" C-m

# if this is a knew tmux session then attach to it, if it already exists switch the session to this project
if [ -n "$TMUX" ]; then
    tmux switch-client -t "$SESH"
else
    tmux attach-session -t "$SESH"
fi
