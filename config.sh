# Use secrets to write personal git config and include dotfiles
DOTFILES_CONFIG="$DOTFILES/config/git/.gitconfig"
git config --global user.name "$GIT_NAME"
git config --global user.email "$GIT_EMAIL"
git config --global include.path "$DOTFILES_CONFIG"
# git config --global user.username "$GIT_USERNAME"
echo "Git user config written and including $DOTFILES_CONFIG\n"