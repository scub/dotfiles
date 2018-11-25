# -*- coding: utf-8 -*-
# vim: ft=bash
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
        echo -en "Usage: ./install.sh -[iwh]\n"
        echo -en "\t-c\tCheck Environment For Tools\n"
        echo -en "\t-i\tDrop Bash Env, (bashrc,vimrc,tmux.conf)\n"
        echo -en "\t-w\tDrop i3 configs including .Xdefaults and .xinitrc\n"
        echo -en "\t-h\tPrint Script Usage\n\n"
}

# Drop Bash Environment Configs
function drop_bashenv() {

        # Various environments are all kept within the environments
        # general workspace. This keeps the system defaults untouched
        # and quick reversion without system damage easy.
        #
        # Quick note about default bias:
        #   - Python: python3 is preferred over python2
        #             by default despite system defaults.
        #   - Ruby: Gems move away from system default, however
        #           the system intepreter is preferred.
        #
        [[ -d "$HOME/space/state" ]] || (mkdir -p $HOME/space/state && echo "created $HOME/space/state for environments")
        
        # If python3 is a thing make our python3
        # environment if it doesn't exist
        if [ -e $(which python3) ]; then
          if [ ! -d $HOME/space/state/global_python3_venv ]; then
            echo "Creating python3 environment in $HOME/space/state/global_python3_env"
            mkdir -p $HOME/space/state/global_python3_venv
            python3 -m venv $HOME/space/state/global_python3_venv
          fi
        fi

        # If python2 is a thing make our python2
        # environment if it doesn't exist. This
        # stanza only fires if virtualenv exists.
        if [ -e $(which python3) ]; then
          if [ -e $(which virtualenv) ]; then
            if [ ! -d $HOME/space/state/global_python2_venv ]; then
              echo "Creating python2 environment in $HOME/space/state/global_python2_env"
              mkdir -p $HOME/space/state/global_python2_venv
              virtualenv $HOME/space/state/global_python2_venv
            fi
          else
            echo '"virtualenv" is not installed within this environment'
          fi
        else
          echo '"python" is not installed within this environment'
        fi

        # If ruby is a thing make our ruby 
        # environment if it doesn't exist. This
        # stanza only fires if gem exists.
        if [ -e $(which ruby) ]; then
          if [ -e $(which gem) ]; then
            if [ ! -d $HOME/space/state/ruby_env ]; then
              mkdir -p $HOME/space/state/ruby_env
            fi
          else
            echo '"gem" is not installed within this environment'
          fi
        else
          echo '"ruby" is not installed within this environment'
        fi

        # Check for localrc overrides file, create it if not found
        [[ -f "$HOME/.localrc" ]] || (cp $PWD/localrc $HOME/.localrc && echo "created $HOME:.localrc for local overrides")

        # Move existing stuff out of the way if necessary
        test -e $HOME/.vimrc && mv $HOME/.vimrc $HOME/.vimrc.$(date +%d%y%m%H%M).orig
        test -e $HOME/.bashrc && mv $HOME/.bashrc $HOME/.bashrc.$(date +%d%y%m%H%M).orig
        test -e $HOME/.tmux.conf && mv $HOME/.tmux.conf $HOME/.tmux.conf.$(date +%d%y%m%H%M).orig

        # Symlink all environment files into place
        ln -s $PWD/vimrc $HOME/.vimrc
        ln -s $PWD/bashrc $HOME/.bashrc
        ln -s $PWD/tmux.conf $HOME/.tmux.conf
}

# Drop i3 Configs, including .Xdefaults and .xinitrc
function drop_i3() {
        if [ ! -e $HOME/.i3 ]; then
                mkdir -p $HOME/.i3
        fi

        cp -vr $PWD/i3/. $HOME/.i3
        cp -v $PWD/xorg/Xdefaults $HOME/.Xdefaults
        cp -v $PWD/xorg/Xresources $HOME/.Xresources
        cp -v $PWD/xorg/xinitrc $HOME/.xinitrc

	# Sort our font out
	cp -v $PWD/xorg/liberation-font /usr/local/share/fonts/liberation
	fc-cache /usr/local/share/fonts/
}

# Check Execution Environment For Tools
function check_env() {
        declare -A tools
        tools=( 
                ['/usr/bin/shred']='SHRED: Secure File Shredder' 
                ['/usr/bin/lsof']='LSOF: List Open Files'
                ['/usr/bin/git']='GIT: Source Control'
                ['/usr/bin/svn']='SVN: Subversion Source Control'
                ['/usr/bin/mtr']='MTR: Robust Traceroute'
                ['/usr/bin/nmap']='NMAP: Network Scanner'
                ['/usr/bin/htop']='HTOP: Fancy Top Replacement'
                ['/usr/bin/strace']='STRACE: Trace Syscalls And Signals'
                ['/usr/bin/python2.7']='PYTHON 2.7: Python v2.7'
                ['/usr/bin/python3']='PYTHON 3: Python v3'
                ['/usr/bin/gcc']='GCC: GNU C Compiler'
                ['/usr/bin/gdb']='GDB: GNU Debugger'
                ['/usr/bin/gpg']='GPG: GNU Privacy Guard'
                ['/usr/bin/vim']='VIM: CLI Based Editor'
                ['/usr/bin/xxd']='XXD: Hex Dumper'
                ['/usr/bin/tmux']='TMUX: Terminal Multiplexer'
        )
      
        echo -e "\t[+] Checking Environment For Toolset"
        for tool in ${!tools[@]}; do
                [ ! -x $tool ] && echo -e "\t\t[!] Missing ${tools[$tool]}!"
        done
        echo -e "\t\t...Done!" 
}


while getopts ":ciw" flag; do
        case $flag in
                c)
                        check_env >&2
                        ;;
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
