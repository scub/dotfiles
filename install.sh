#!/bin/bash

DOTFILES=$HOME/.dotfiles
. $DOTFILES/install-scripts/asdf.sh
. $DOTFILES/environment/utils.sh

ARCH=$(uname -m)
OS_GENERIC=$(uname -s)
DERIVED_SHELL=$(derive_shell)

# Installer hooks
pkg_install() {
  test -f $DOTFILES/install-scripts/$(uname -s).$(uname -m).sh \
    && . $DOTFILES/install-scripts/$(uname -s).$(uname -m).sh
}

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

  case $OS_GENERIC in
    Darwin)
      echo "no steps cataloged"
      ;;
    Linux)
      which apt-get >/dev/null && 
        sudo apt-get install -y build-essential

      case $DERIVED_SHELL in
        zsh)
          echo >> $HOME/.zshrc
          echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"' >> $HOME/.bashrc
          eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"
          ;;
        bash)
          echo >> $HOME/.bashrc
          echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"' >> $HOME/.bashrc
          eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"
          ;;
        *)
          echo "Unsupported shell; expecting zsh/bash: $DERIVED_SHELL"
          ;;
      esac
      ;;
    *)
      echo "Unsupported OS, expecting Linux/Darwin: $OS_GENERIC"
      ;;
  esac
}

#
# Clone or pull latest DotFiles
#
if [ ! -d "$DOTFILES" ]; then
  echo -e "[+] Cloning DotFiles to $DOTFILES\n"
  command git clone git@github.com:scub/dotenv-new $DOTFILES 2>/dev/null
  command cd $DOTFILES
else
  echo -e "[-] DotFiles repo exists at $DOTFILES, pulling latest"
  command pushd $DOTFILES >/dev/null 2>&1
  command git pull origin HEAD >/dev/null 2>&1
  command popd >/dev/null 2>&1
fi

#
# Install any prereqs for configuration (os-dependent)
#
case $OS_GENERIC in
  Darwin)
    echo "[+] OSX instrumentation"
    xcode_install
    brew_install
    export BREWFILE="$DOTFILES/Brewfile"
    export DARWIN=1
    ;;
  Linux)
    echo "[+] Linux instrumentation"
    # pkg_install
    brew_install
    export BREWFILE="$DOTFILES/Brewfile.$OS_GENERIC.$ARCH"
    export LINUX=1
    ;;
  *)
    echo "[!] Im on an unsupported OS: $OS_GENERIC"
    exit 1
    ;;
esac

#
# Install Homebrew bundle
#
echo -e "\n[+] Installing Homebrew bundle"
command brew bundle install --verbose --file=$BREWFILE

#
# Link configs with Stow
#
STOWS=$DOTFILES/config
echo -e "\n[+] Linking Stow packages"
command stow -v -t $HOME -d $STOWS -S stow # link stow config before creating other links
command stow -v -t $HOME -d $STOWS -S asdf tmux vim p10k zim zsh bash

test "$DARWIN" == "1"                                             \
  && command stow -v -t $HOME -d $STOWS -S work-git work-npm  \
  || command stow -v -t $HOME -d $STOWS -S git npm

# Install asdf and plugins
asdf_update_or_install

# Install plugin extensions / tools
. $DOTFILES/install-scripts/enable_extensions.sh

#
# Verify secrets are populated
#
test -f $DOTFILES/environment/secret.sh                     \
  || echo "Unable to find $DOTFILES/environment/secret.sh"  \
  && {
    echo "sourcing $DOTFILES/environment/secret.sh"         \
      && source $DOTFILES/environment/secret.sh
  }

for SEC_NAME in GIT_NAME                  \
                  GIT_EMAIL               \
                  GIT_USERNAME            \
                  HOMETOWN                \
                  NPM_TOKEN               \
                  ONEP_VAULT              \
                  ONEP_ENV_ITEM           \
                  INTERNAL_REG            \
                  QMAN_URL                \
                  TELEPORT_ENTRY; do
    secret get $SEC_NAME >/dev/null 2>&1  \
      || {
        read -rs -p "[+] Secret $SEC_NAME not found, enter it: " SEC_VAL; echo
        secret set $SEC_NAME $SEC_VAL
      }
done

# Done
echo -e "\n[!] DotFiles installed, restart shell for changes to take effect"

# Prompt to open docs
echo -e "\nOpen documentation for next steps with:\n   glow \$DOTFILES/docs/README.md"
