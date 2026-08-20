# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

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
export PATH=/opt/homebrew/bin:$PATH
export PATH=/opt/homebrew/sbin:$PATH
export PATH=/opt/homebrew/share/google-cloud-sdk/bin:$PATH
export MANPATH=/usr/local/man:$MANPATH

# Source secrets lib first
source $DOTFILES/environment/secret.sh

# OSX: Export dotfiles secrets
uname -s | grep -c "Darwin" >/dev/null && {
  secret export GIT_NAME --silent
  secret export GIT_EMAIL --silent
  secret export GIT_USERNAME --silent
  secret export HOME_TOWN --silent
  secret export INTERNAL_REG --silent
  secret export NPM_TOKEN --silent
}

# Source environment extensions
source $DOTFILES/environment/1pass.sh
source $DOTFILES/environment/asdf.sh
source $DOTFILES/environment/aws-helpers.sh
source $DOTFILES/environment/certs.sh
source $DOTFILES/environment/docker.sh
source $DOTFILES/environment/git.sh
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
source $DOTFILES/environment/zsh.sh
source $DOTFILES/environment/yarn.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
