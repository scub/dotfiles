#!/bin/bash

install_ubuntu() {
    sudo apt-get update             \
        && sudo apt-get install -y  \
            ansible                 \
            ansible-core            \
            ansible-lint            \
            python3-ansible-compat  \
            build-essential         \
            curl                    \
            dirmngr                 \
            gnome-keyring           \
            gpg                     \
            htop                    \
            i3                      \
            jq                      \
            libssl-dev              \
            libbz2-dev              \
            libffi-dev              \
            liblzma-dev             \
            libncursesw5-dev        \
            libreadline-dev         \
            libsqlite3-dev          \
            libxml2-dev             \
            libxmlsec1-dev          \
            libyaml-dev             \
            llvm                    \
            make                    \
            masscan                 \
            mtr                     \
            nmap                    \
            sqlite3                 \
            tk-dev                  \
            wget                    \
            xz-utils                \
            yamllint                \
            yq                      \
            yubikey-manager         \
            zlib1g-dev
}

OS_RESOLVED=$(egrep '^NAME=' /etc/os-release | cut -d'=' -f2 | tr -d '"')

case $OS_RESOLVED in
    Ubuntu)
        echo "Ubuntu: $OS_RESOLVED"
        install_ubuntu
        ;;
    "Fedora Linux")
        echo "Detected Fedora"
        ;;
    "Arch Linux")
        echo "Detected Arch"
        ;;
    *)
        echo "Unsupported OS: $OS_RESOLVED"
        ;;
esac

