
resolve_os() {
    test -f /etc/os-release                                                 \
    && echo $(egrep '^NAME=' /etc/os-release | cut -d'=' -f2 | tr -d '"')   \
    || uname -s
}

. $HOME/.dotfiles/install-scripts/bitwarden.sh
. $HOME/.dotfiles/install-scripts/ansible.sh
. $HOME/.dotfiles/install-scripts/rubygems.sh
# . $HOME/.dotfiles/install-scripts/pypackages.sh

OS_RESOLVED=$(resolve_os)

echo "[!] Installing extensions for OS: $OS_RESOLVED"


case $OS_RESOLVED in
    Darwin)
        install_bitwarden_direnv_ext
        install_rubygem_tools
        ;;
    Ubuntu)
        install_ansible_collections
        install_bitwarden_direnv_ext
        install_rubygem_tools
        ;;
    "Fedora Linux")
        echo "Detected Fedora: $OS_RESOLVED"
        ;;
    "Arch Linux")
        echo "Detected Arch: $OS_RESOLVED"
        ;;
    *)
        echo "Unsupported OS: $OS_RESOLVED"
        ;;
esac
