#
# Enable ansible community plugins
#
install_ansible_collections() {
    which ansible-galaxy >/dev/null                                     \
        && ansible-galaxy collection install community.general --force  \
        || echo "[!] ansible-galaxy is not installed, unable to add community modules"
}
