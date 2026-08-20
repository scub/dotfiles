# Use hyphen-insensitive completion
HYPHEN_INSENSITIVE="true"
# Change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=30
# Enable command auto-correction.
ENABLE_CORRECTION="true"
# Display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"
# Disable marking untracked files under VCS as dirty
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Enable auto-completion for shell commands on history search
zstyle ':autocomplete:*' default-context history-incremental-search-backward

zstyle ':omz:update' mode auto      # update automatically without asking
zstyle ':omz:update' frequency 13
