# Set location for brew bundle file
export HOMEBREW_BUNDLE_FILE=$HOME/brewfile

# Update all installed Homebrew modules
alias upbrew="brew update && brew upgrade && brew cleanup && brew doctor && say 'brews done'"

# Update all installed Homebrew casks
alias upcask="brew upgrade --cask --yes && say 'casks done'"