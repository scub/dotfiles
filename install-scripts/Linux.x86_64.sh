#!/bin/bash

install_ubuntu() {
    sudo apt-get update             \
        && sudo apt-get install -y  \
            ansible                 \
            ansible-core            \
            ansible-lint            \
            build-essential         \
            curl                    \
            dirmngr                 \
            gnome-keyring           \
            golang                  \
            gpg                     \
            htop                    \
            i3                      \
            jq                      \
            libbz2-dev              \
            libffi-dev              \
            liblzma-dev             \
            libncursesw5-dev        \
            libreadline-dev         \
            libsecret-tools         \
            libsqlite3-dev          \
            libssl-dev              \
            libxml2-dev             \
            libxmlsec1-dev          \
            libyaml-dev             \
            llvm                    \
            make                    \
            masscan                 \
            mtr                     \
            nmap                    \
            python3-ansible-compat  \
            sqlite3                 \
            tk-dev                  \
            wget                    \
            xz-utils                \
            yamllint                \
            yq                      \
            yubikey-manager         \
            zlib1g-dev              \
            zsh                     \
            zsh-common              \
            zsh-dev                 \
            zsh-doc                 \
            zsh-syntax-highlighting \
            zsh-theme-powerlevel9k
}

OS_RESOLVED=$(egrep '^NAME=' /etc/os-release | cut -d'=' -f2 | tr -d '"')


case $OS_RESOLVED in
    Ubuntu)
        echo "[+] Ubuntu identified, running pkg install"
        install_ubuntu
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

