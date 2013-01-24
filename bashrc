# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Proper umask
umask 077

# Path
if [ -e $HOME/sbin ]; then
	PATH=$PATH:$HOME/sbin/
	export PATH
fi

# Custom Bindings 
bind '"\ew"':"\"ssh -i $HOME/.ssh/draugr -p 6996 scub@96.126.107.149\C-m\""
bind '"\ea\ed"':"\"echo 'Auto Destruct Sequence Has Been Activated!!!'\C-m\""

## ALIAS
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Alert for long running cmds. Usage: sleep 1; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1| sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

## FUNCTIONS
# Disassemble binary into opcodes
disas() {
	gcc -pipe -S -o - -O -g $* | as -aldh -o /dev/null
}

# Create Directory and Change Into It
cmkdir() {
	mkdir -p $*
	cd $*
}

# Create Executable File
touche() {
	touch $*
	chmod 700 $*
}
