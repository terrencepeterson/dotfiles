# ---- PATH ----
export PATH="$HOME/bin:/usr/local/bin:$PATH:$HOME/.local/bin/projects"
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"

# ---- HISTORY ----
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS

# ---- OPTIONS ----
setopt AUTO_CD
setopt INTERACTIVE_COMMENTS
setopt NO_BEEP
setopt CORRECT

autoload -Uz colors
colors

autoload -Uz compinit
compinit

# ---- ALIASES ----
for f in "$HOME/.shell.d/"*.sh(N); do
    source "$f"
done

zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Menu selection: highlights current item
zstyle ':completion:*' menu select
zstyle ':completion:*' menu select=2
bindkey '^[[A' up-line-or-history
bindkey '^[[B' down-line-or-history

# ---- PROMPT ----
PROMPT='%B%F{red}%n » %1~%b $ %f'

# ---- Initialisations ----
# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

export EDITOR=nvim

eval "$(starship init zsh)"
source ~/.lscolours.sh
