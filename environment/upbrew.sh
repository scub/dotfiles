# Set location for brew bundle file
case $OS_GENERIC in
  Darwin)
    HOMEBREW_BUNDLE_FILE="$DOTFILES/Brewfile"
    ;;
  Linux)
    HOMEBREW_BUNDLE_FILE="$DOTFILES/Brewfile.$OS_GENERIC.$ARCH"
    ;;
  *)
    echo "[!] Im on an unsupported OS: $OS_GENERIC"
    export HOMEBREW_BUNDLE_FILE=""
    ;;
esac


# Update all installed Homebrew modules
alias upbrew="brew update && brew upgrade && brew cleanup && brew doctor && say 'brews done'"

# Update all installed Homebrew casks
alias upcask="brew upgrade --cask --yes && say 'casks done'"