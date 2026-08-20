#!/bin/bash

DOTFILES=$HOME/.dotfiles
OS_NAME=$(uname -s)
ARCH=$(uname -m)

# Installer hooks
xcode_install() {
  xcode-select -p 2>&1 >/dev/null && echo "[-] XCode installed, skipping" || {
      echo "[+] Installing xcode, this will take a while"
      xcode-select --install
  }
}

brew_install() {
  which brew 2>&1 >/dev/null && echo "[-] Homebrew installed, skipping" || {
    echo "[+] Installing homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  }
}

#
# Clone and checkout DotFiles
#
if [ ! -d "$DOTFILES" ]; then
  echo -e "[+] Cloning DotFiles to $DOTFILES\n"
  command git clone git@github.com:scub/dotenv-new $DOTFILES
  command cd $DOTFILES
else
  echo -e "[-] DotFiles repo exists at $DOTFILES, pulling latest"
  command pushd $DOTFILES
  command git pull origin HEAD
  command popd
fi

#
# Install any prereqs for configuration (os-dependent)
#
case $OS_NAME in
  Darwin)
    echo "Im on osx"
    xcode_install
    brew_install
    ;;
  Linux)
    echo "Im on linux"
    brew_install
    ;;
  *)
    echo "Im on an unsupported OS: $OS_NAME";;
esac

#
# Install Homebrew bundle
#
echo -e "\n[+] Installing Homebrew bundle"
command brew bundle install --verbose --file=$DOTFILES/brewfile

#
# Link user configs with Stow
#
STOWS=$DOTFILES/config
echo -e "\n[+] Linking Stow packages"
command stow -v -t $HOME -d $STOWS -S stow # link stow config before creating other links
command stow -v -t $HOME -d $STOWS -S asdf git npm tmux vim p10k zim zsh

#  npm zim zsh

#
# OSX: Verify secrets populated
#
test $OS_NAME = "Darwin"        \
  && for SEC_NAME in GIT_NAME   \
                  GIT_EMAIL     \
                  GIT_USERNAME  \
                  HOMETOWN      \
                  NPM_TOKEN     \
                  1P_VAULT      \
                  1P_ENV_ITEM   \
                  INTERNAL_REG  \
                  QMAN_URL      \
                  TELEPORT_ENTRY; do
    secret get $SEC_NAME >/dev/null 2>&1 \
      || {
        read -rs -p "[+] Secret $SEC_NAME not found, enter it: " SEC_VAL; echo
        secret set $SEC_NAME $SEC_VAL
      }
  done

# Done
echo -e "\n[!] DotFiles installed, restart shell for changes to take effect"

# Prompt to open docs
echo -e "\nOpen documentation for next steps with:\n   glow \$DOTFILES/docs/README.md"