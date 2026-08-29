
. $HOME/.dotfiles/install-scripts/bitwarden.sh
. $HOME/.dotfiles/install-scripts/ansible.sh
. $HOME/.dotfiles/install-scripts/rubygems.sh
# . $HOME/.dotfiles/install-scripts/pypackages.sh

OS_RESOLVED=$(egrep '^NAME=' /etc/os-release || echo "NAME=$(uname -s)" | cut -d'=' -f2 | tr -d '"' || uname -s)

case $OS_RESOLVED in
    Darwin)
        echo "OSX: $OS_RESOLVED"
        install_bitwarden_direnv_ext
        install_rubygem_tools
        ;;
    Ubuntu)
        echo "Ubuntu: $OS_RESOLVED"
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
