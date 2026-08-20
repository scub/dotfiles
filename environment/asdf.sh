# ASDF
# http://asdf-vm.com/
# source $(brew --prefix asdf)/libexec/asdf.sh

asdf_plugins_add() {
  INSTALLED_PLUGIN_LIST=$(asdf plugin list 2>/dev/null)
  for ASDF_PLUGIN in awscli           \
                      golang          \
                      helm-diff       \
                      helm-docs       \
                      helm            \
                      helmfile        \
                      just            \
                      kops            \
                      kubectl         \
                      kustomize       \
                      nodejs          \
                      php             \
                      pnpm            \
                      poetry          \
                      python          \
                      ruby            \
                      terraform-docs  \
                      terraform       \
                      yarn; do

    echo $INSTALLED_PLUGIN_LIST | grep -c $ASDF_PLUGIN   \
      && echo "[-] $ASDF_PLUGIN already installed, skipping" \
      || {
        echo "[+] Installing asdf plugin: $ASDF_PLUGIN"
        asdf plugin add $ASDF_PLUGIN
        asdf install $ASDF_PLUGIN latest
      }
    echo $ASDF_PLUGIN
  done
}

# autoload -Uz compinit
# compinit