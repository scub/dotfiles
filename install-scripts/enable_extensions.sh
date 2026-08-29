
. $HOME/.dotfiles/installer-scripts/bitwarden.sh
. $HOME/.dotfiles/installer-scripts/ansible.sh
. $HOME/.dotfiles/installer-scripts/rubygems.sh
. $HOME/.dotfiles/installer-scripts/pypackages.sh

OS_RESOLVED=$(egrep '^NAME=' /etc/os-release | cut -d'=' -f2 | tr -d '"' || uname -s)

case $OS_RESOLVED in
    Darwin)
        echo "OSX: $OS_RESOLVED"
        install_bitwarden_direnv_ext
        install_rubygem_tools
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
