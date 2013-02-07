#!/bin/bash
#
# [ 02/05/2013 ]
#       Trivial Installer For Environment Configuration
#
#       Usage: ./install.sh -[iwh]
#               -i      Drop bash environment (bashrc, vimrc, tmux.conf)
#               -w      Drop i3 Configs, including .xinitrc and .Xdefaults
#               -h      Print Application Usage
#

# Print Application Usage
function print_usage() {
        echo -en "Usage: ./install.sh -[iwh]\n\t-i\tDrop Bash Env, (bashrc,vimrc,tmux.conf)\n"
        echo -en "\t-w\tDrop i3 configs including .Xdefaults and .xinitrc\n"
        echo -en "\t-h\tPrint Script Usage\n\n"
}

# Drop Bash Environment Configs
function drop_bashenv() {
        cp -vr $PWD/vimrc $HOME/.vimrc
        cp -vr $PWD/bashrc $HOME/.bashrc
        cp -vr $PWD/tmux.conf $HOME/.tmux.conf
}

# Drop i3 Configs, including .Xdefaults and .xinitrc
function drop_i3() {
        if [ ! -e $HOME/.i3 ]; then
                mkdir -p $HOME/.i3
        fi

        cp -vr $PWD/i3/. $HOME/.i3
        cp -vr $PWD/Xdefaults $HOME/.Xdefaults
        cp -vr $PWD/xinitrc $HOME/.xinitrc        
}

while getopts ":iw" flag; do
        case $flag in
                i)
                        drop_bashenv >&2
                        ;;
                w) 
                        drop_i3 >&2
                        ;;
                \?)
                        print_usage
                        ;;
        esac
done
