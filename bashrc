# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Proper umask
umask 077

# Path
if [ ! -e $HOME/sbin ]; then
        mkdir $HOME/sbin
fi

PATH=$PATH:$HOME/sbin/
export PATH

# Custom Bindings 
bind '"\ea\ed"':"\"echo 'Auto Destruct Sequence Has Been Activated!!!'\C-m\""

## ALIAS
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'


# Quick CLI Pasting
alias snip="curl -F 'paste=<-' http://s.drk.sc"
alias gnsip='git diff | snip'

# Quick HTTP Server
alias pyserv='python -c "import SimpleHTTPServer, SocketServer, BaseHTTPServer; SimpleHTTPServer.test(SimpleHTTPServer.SimpleHTTPRequestHandler, type('"'"'Server'"'"', (BaseHTTPServer.HTTPServer, SocketServer.ThreadingMixIn, object), {}))" 9090'

# Alert for long running cmds. Usage: sleep 1; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1| sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias ialert='i3-nagbar -m "[$?] Job Completed ($( echo -n $( history | tail -n2 | head -n1 | cut -d\  -f 4- ) )")'

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

# Quickly Generate Password of given length, defaults to 10 characters
genpass() {
        test -z "$1" && LENGTH=10 || LENGTH=$1
        python -c "from random import choice; import string; print ''.join( [ choice( string.printable.split( '\"')[0] ) for x in range( $LENGTH ) ] );"
}
