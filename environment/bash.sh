# New history per day, never delete
export HISTFILE="$HOME/.bash_history_$(date +'%Y-%m-%d')"
export HISTSIZE=-1
export HISTFILESIZE=-1
export HISTCONTROL=ignoreboth
shopt -s histappend
PROMPT_COMMAND="history -a; ${PROMPT_COMMAND:-}"