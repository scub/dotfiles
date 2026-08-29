# ASDF
# http://asdf-vm.com/

ASDF_PLUGIN_LIST="""
awscli
direnv
golang
helm
helm-diff
helm-docs
helmfile
just
kops
kubectl
kustomize
nodejs
php
pnpm
poetry
python
ruby
terraform
terraform-docs
uv
yarn
"""

asdf_add_plugins() {
  INSTALLED_PLUGIN_LIST=$(asdf plugin list 2>/dev/null)

  echo "[+] Installing asdf plugins"
  for ASDF_PLUGIN in $ASDF_PLUGIN_LIST; do
    echo $INSTALLED_PLUGIN_LIST | grep -c $ASDF_PLUGIN >/dev/null   \
      && echo "\t[-] $ASDF_PLUGIN already installed, skipping"        \
      || {
        echo "\t[+] Installing latest version of $ASDF_PLUGIN"
        asdf plugin add $ASDF_PLUGIN
        asdf install $ASDF_PLUGIN latest
      }
  done

  echo "\t[+] Installing defaults from .tool-versions"
  asdf install
}

asdf_update_or_install() {

  which go make >/dev/null || {
    echo "[!] unable to install asdf without 'curl', 'git', 'bash' and 'make'"
    return 1
  }

  . $HOME/.dotfiles/environment/utils.sh
  . $HOME/.dotfiles/environment/github.sh

  ASDF_VERSION=$(github_latest_release asdf-vm asdf)
  DERIVED_SHELL=$(derive_shell)

  test -d $HOME/.asdf || {
      echo "[!] ASDF not found, installing version $ASDF_VERSION"

      git clone -b $ASDF_VERSION git@github.com:asdf-vm/asdf.git $HOME/.asdf  \
          && cd $HOME/.asdf                                                   \
          && make                                                             \
          && ln -s $HOME/.asdf/asdf /usr/local/bin/asdf 2>&1 >/dev/null       \
            || sudo ln -s $HOME/.asdf/asdf /usr/local/bin/asdf
          
      cd $HOME/.dotfiles 2>&1 >/dev/null
  }

  which asdf >/dev/null   \
    && asdf_add_plugins   \
    || {
      echo "[!] asdf not found in PATH, unable to install plugins or populate shell profiles [$PATH]"
      return 1
    }

  ADD_ASDF_SHIM_TO_PATH='export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"'
  echo "\t[+] Checking shell for path/completion"
  case $DERIVED_SHELL in
    bash)
      ADD_ASDF_COMPLETION='. <(asdf completion bash)'
      grep -c "$ADD_ASDF_SHIM_TO_PATH" $HOME/.bashrc >/dev/null || echo "\n$ADD_ASDF_SHIM_TO_PATH" >> $HOME/.bashrc
      grep -c "$ADD_ASDF_COMPLETION" $HOME/.bashrc >/dev/null || echo "\n$ADD_ASDF_COMPLETION" >> $HOME/.bashrc
      ;;
    zsh)
      ASDF_FPATH_SETTINGS='fpath=(${ASDF_DATA_DIR:-$HOME/.asdf}/completions $fpath)'
      ASDF_AUTOLOAD='autoload -Uz compinit && compinit/'
      test -d ${ASDF_DATA_DIR:-$HOME/.asdf}/completions/_asdf \
        || asdf completion zsh > ${ASDF_DATA_DIR:-$HOME/.asdf}/completions/_asdf
      
      grep -c "$FPATH_SETTINGS" $HOME/.zshrc >/dev/null || echo "\n$FPATH_SETTINGS" >> $HOME/.zshrc
      grep -c "$ASDF_AUTOLOAD" $HOME/.zshrc >/dev/null || echo "\n$ASDF_AUTOLOAD" >> $HOME/.zshrc
      ;;
    *) 
      echo "[!] $SHELL is not supported; options zsh/bash"
      ;;
  esac

}
