#
# Bitwarden direnv extension setup
#

bitwarden_install_direnv_ext() {\
    test -d $HOME/.config/direnv/lib && {
        cp $HOME/.dotfiles/install-scripts/sbin/bw_to_env.sh $HOME/.config/direnv/lib/
        chmod 0755 $HOME/.config/direnv/lib/bw_to_env.sh
    } || echo "[!] direnv config not found, unable to add bitwarden harness"
}
