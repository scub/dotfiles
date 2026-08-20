# Git config
export GIT_CEILING_DIRECTORIES=$HOME

# Ephemeral tokens
# export GLAB_TOKEN=$(glab token create --user @me --scope write_repository --scope api --duration 7d ephemeral-cli-token)

alias gb='git branch'
alias gcm='git commit'
alias gco="git checkout"
alias gct='git checkout'
alias gd='git diff'
alias gds='git diff --staged'
alias gg='git grep'
alias glo='git log --oneline'
alias gnb="git add . ; git stash ; git checkout main ; git pull origin main ; git checkout -b"
alias gp='git push'
alias gpo="git pull origin HEAD"
alias gpoh="git push origin HEAD"
alias gpr='git pull --rebase'
alias gredo="git commit -S --amend --no-edit --reset-author ; git push origin HEAD -f"
alias gs='git status'
alias gsu='git status -uno'

# Quick switch git config
glabconf() {
  SCOPE="--local"
  if [[ "$1" == "global" ]]; then
    SCOPE="--global"
  fi
  git config $SCOPE user.signingkey ~/.ssh/id_rsa.pub
  git config $SCOPE gpg.format ssh
}

ghubconf() {
  git config --local user.signingkey BA09034A2B81C0E8
  git config --local gpg.format openpgp
}

# Pull in our latest git changes
gu() {
  CURRENT_BRANCH=$(git branch | egrep '^\*' | cut -d' ' -f2)
  DEFAULT_BRANCH=$(git branch | egrep -c 'main' >/dev/null && echo 'main' || { git branch | egrep -c 'master' >/dev/null && echo 'master' || echo 'NOT_FOUND'})

  if [ $DEFAULT_BRANCH == "NOT_FOUND" ]; then
    echo "[!] Unable to identify default branch, bailing"
    return 1
  else
    echo "[+] Pulling in latest changes"
    git add .
    git stash
    git checkout $DEFAULT_BRANCH
    git pull origin $DEFAULT_BRANCH
    git checkout $CURRENT_BRANCH
    git stash pop 
  fi 
}