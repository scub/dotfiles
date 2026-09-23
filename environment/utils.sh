# Create Directory and Change Into It
cmkdir() {
	mkdir -p $*
	cd $*
}

# build single csv string from \n delimited file
csv() {
  if [ $# -eq 1 ]; then
    while read line; do
      echo "'${line}'"
    done < $1 | tr '\n' ','
  fi
}

## Kill ports in use by process
killport () {
  lsof -P | grep ":$@" | awk '{print $2}' | xargs kill -9 
}

## Trigger OSX alert
make-alert() {
  osascript -e "display notification \"$*\" with title \"Complete\"" 
}

# Create Executable File
te() {
	touch $*
	chmod 700 $*
}

# Quickly Generate Password of given length, defaults to 10 characters
genpass() {
  test -z "$1" && LENGTH=10 || LENGTH=$1
  python -c "from random import choice; import string; print ''.join( [ choice( string.printable.split( '\"')[0] ) for x in range( $LENGTH ) ] );"
}

alias scripts="cat package.json | jq '.scripts'"
alias readme="cat README.md | glow"
alias code="open -a 'Visual Studio Code'"

# Expose current directory from an ad-hoc webserver 
alias pyserv='python -c "import SimpleHTTPServer, SocketServer, BaseHTTPServer; SimpleHTTPServer.test(SimpleHTTPServer.SimpleHTTPRequestHandler, type('"'"'Server'"'"', (BaseHTTPServer.HTTPServer, SocketServer.ThreadingMixIn, object), {}))" 9090'
