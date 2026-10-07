OS_NAME=$(uname -m)

export DOTFILES=$HOME/.dotfiles
alias dotfiles='cd $DOTFILES'
alias dotfiles-install='. $DOTFILES/install.sh'
alias dotfiles-config='. $DOTFILES/config.sh'

# Extend path with Homebrew and user binary paths
export PATH=/usr/local/sbin:$PATH
export PATH=/usr/bin:$PATH
export PATH=/usr/sbin:$PATH
export PATH=/sbin:$PATH
export PATH=/bin:$PATH
export PATH=/private/tmp:$PATH
export PATH=/usr/local/bin:$PATH
export PATH=$HOME/bin:$PATH
export PATH=$HOME/.local/bin:$PATH

# Homebrew paths
case $OS_NAME in
    Darwin)
        export PATH=/opt/homebrew/bin:$PATH
        export PATH=/opt/homebrew/sbin:$PATH
        export PATH=/opt/homebrew/share/google-cloud-sdk/bin:$PATH
        ;;
    Linux)
        export PATH=/home/linuxbrew/.linuxbrew/bin:$PATH
        export PATH=/home/linuxbrew/.linuxbrew/sbin:$PATH
        ;;
esac

# ASDF at the top of the path stack
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
export MANPATH=/usr/local/man:$MANPATH

# Source secrets lib first
source $DOTFILES/environment/secret.sh

# Export dotfiles secrets
secret export GIT_NAME --silent
secret export GIT_EMAIL --silent
secret export GIT_USERNAME --silent
secret export HOME_TOWN --silent
secret export NPM_TOKEN --silent
uname -s | grep -c "Darwin" >/dev/null && {
  secret export ONEP_VAULT --silent
  secret export ONEP_ENV_ITEM --silent
  secret export INTERNAL_REG --internal
  secret export QMAN_URL --internal
  secret export TELEPORT_ENTRY --internal
}

# Source shell config
source $DOTFILES/environment/bash.sh

# Source environment extensions
source $DOTFILES/environment/1pass.sh
source $DOTFILES/environment/aws-helpers.sh
source $DOTFILES/environment/certs.sh
source $DOTFILES/environment/docker.sh
source $DOTFILES/environment/git.sh
source $DOTFILES/environment/github.sh
source $DOTFILES/environment/granted.sh
source $DOTFILES/environment/k8s.sh
source $DOTFILES/environment/pnpm.sh
source $DOTFILES/environment/quicknav_aliases.sh
source $DOTFILES/environment/teleport.sh
source $DOTFILES/environment/terraform.sh
source $DOTFILES/environment/test-kitchen.sh
source $DOTFILES/environment/upbrew.sh
source $DOTFILES/environment/utils.sh
source $DOTFILES/environment/vagrant.sh
source $DOTFILES/environment/virtualbox.sh
source $DOTFILES/environment/weather.sh
source $DOTFILES/environment/work.sh
source $DOTFILES/environment/zim.sh

# Oh my bash config
# Enable the subsequent settings only in interactive sessions
case $- in
  *i*) ;;
    *) return;;
esac



if [ -d $HOME/.oh-my-bash ]; then
    export OSH=$HOME/.oh-my-bash

    OSH_THEME="lambda"

    export UPDATE_OSH_DAYS=13
    ENABLE_CORRECTION="true"
    COMPLETION_WAITING_DOTS="true"
    DISABLE_UNTRACKED_FILES_DIRTY="true"
    SCM_GIT_DISABLE_UNTRACKED_DIRTY="true"
    HIST_STAMPS=[mm/dd/yyyy]
    OMB_USE_SUDO=true
    OMB_PROMPT_SHOW_PYTHON_VENV=true

    completions=(
      git
      asdf
      composer
      ssh
    )

    aliases=(
      general
    )

    plugins=(
      asdf
      brew
      fzf
      bashmarks
      sudo
      kubectl
      direnv
      donottrack
      colored-man-pages
      tmux
    )

    source "$OSH"/oh-my-bash.sh

    # Preferred editor for local and remote sessions
    if [[ -n $SSH_CONNECTION ]]; then
      export EDITOR='vim'
    else
      export EDITOR='nvim'
    fi

    # Compilation flags
    export ARCHFLAGS="-arch x86_64"

    export GPG_TTY=$(tty)
    gpg-connect-agent updatestartuptty /bye >/dev/null

    SSH_ENV="$HOME/.ssh/environment"
    # Function to start a new SSH agent
    start_agent() {
        echo "Initialising new SSH agent..."
        ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
        echo "succeeded"
        chmod 600 "${SSH_ENV}"
        . "${SSH_ENV}" > /dev/null
    }

    # Load existing environment if file exists
    if [ -f "${SSH_ENV}" ]; then
        . "${SSH_ENV}" > /dev/null
        ps -ef | grep ${SSH_AGENT_PID} | grep 'ssh-agent$' >/dev/null || {
          start_agent
        }
    else
      start_agent
    fi

    # pnpm
    if [ -d $HOME/.local/share/pnpm ]; then
        export PNPM_HOME=$HOME/.local/share/pnpm
        case ":$PATH:" in
          *":$PNPM_HOME/bin:"*) ;;
          *) export PATH="$PNPM_HOME/bin:$PATH" ;;
        esac
    fi
    # pnpm end
fi