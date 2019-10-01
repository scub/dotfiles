#
# Theres no shell like Skoobies ${HOME}/.bashrc
#

### Quick Color Definitions
export RED="\033[31m"
export DARK_YELLOW="\033[33m"
export CYAN="\033[36m"
export BLUE="\033[34m"
export MAGENTA="\033[35m"
export ORANGE="\033[91m"
export CLEAR="\033[0m"


# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# .rawrusrc

### Source global definitions
export HAPMOJI=("¯\_(ツ)_/¯" "ʕᵔᴥᵔʔ" "ヽ(´ー｀)ノ" "☜(⌒▽⌒)☞" "( ͡° ͜ʖ ͡°)" "(づ￣ ³￣)づ" "◔_◔" "ԅ(≖‿≖ԅ)" "{•̃_•̃}" "(∩｀-´)⊃━☆ﾟ.*･｡ﾟ" "(っ▀¯▀)" "ヽ( •_)ᕗ")
export SADMOJI=("[¬º-°]¬" "(Ծ‸ Ծ)" "(҂◡_◡)" "ミ●﹏☉ミ" "(⊙_◎)" "(´･_･\`)" "(⊙.☉)7" "⊙﹏⊙" "ᕦ(ò_óˇ)ᕤ" "ε=ε=ε=┌(;*´Д\`)ﾉ" "ლ(｀ー´ლ)" "ʕ •\`ᴥ•´ʔ" "ʕノ•ᴥ•ʔノ ︵ ┻━┻")

# Add local overrides ~/.localrc if it exists
[[ -e "${HOME}/.localrc" ]] && source ${HOME}/.localrc

# Add AWS functions if available
[[ -e "${HOME}/.bash.aws" ]] && source ${HOME}/.bash.aws

# Add local ~/sbin to PATH if it exists
[[ -s "${HOME}/sbin" ]] && export PATH="$PATH:~/sbin"

# Set EDITOR/GIT_EDITOR to vim where able and necessary
[[ -s "$(which vim 2>/dev/null)" ]] &&          \
  export EDITOR="$(which vim)" &&               \
  [[ -s "$(which git 2>/dev/null)" ]] &&        \
    export GIT_EDITOR=$(which vim 2>/dev/null)

# Pull in system bashrc if it exists
[[ -s "/etc/bashrc" ]] && . /etc/bashrc

# python3 -m venv ${HOME}/space/global_python3_venv
[[ -z "${VIRTUAL_ENV}" ]] && \
  [[ -d "${HOME}/space/state/global_python3_venv" ]] && \
    source ${HOME}/space/state/global_python3_venv/bin/activate

# Import global ssh-agent
[[ -e "/tmp/.global-ssh-agent" ]] && \
  eval $(</tmp/.global-ssh-agent) 2>&1 > /dev/null

######
#
# CURRENTLY DEFUNCT AND LIABLE TO BRICK CONVENTIONAL INSTALLS
# IMPLEMENTATION REQUIRES FURTHER STUDY BEFORE ENABLING.
#
# Ruby: non-system gem environment
#
#[[ -s "$(which ruby 2>/dev/null)" ]] && \
#  [[ -s "$(which gem 2>/dev/null)" ]] && \
#    [[ -d "${HOME}/space/state/ruby_env" ]] && \
#      export GEM_PATH="${HOME}/space/state/ruby_env" && \
#      export GEM_HOME="${HOME}/space/state/ruby_env" && \
#      export PATH="$PATH:${HOME}/space/state/ruby_env"

# Proper umask
#umask 077

# [TMUX] If were in tmux set the window name to our host
if [ "$TERM" == "screen-256color" ] ||
   [ "$TERM" == "screen" ] ||
   [ "$TERM" == "tmux" ]; then

   printf "\033k$(hostname -s)\033\\"
fi

# Fun Bindings
bind '"\ea\ed"':"\"echo 'Auto Destruct Sequence Has Been Activated!!!'\C-m\""

### Aliases
# Remap clear to force shell stdin to the bottom
alias clear='clear; tput cup $LINES 0'

# Quick commands
alias ..='cd ..'
alias ocd='cd ${OLDPWD}'
alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias le='less'
alias l='ls -lisaG'

# List top level keys ofjson object piped to me
alias jkeys='python -c "import sys, json; false=False; true=True; x=json.loads(sys.stdin.readline()); print(x.keys())"'

# Quick HTTP Server
alias pyserv='python -c "import SimpleHTTPServer, SocketServer, BaseHTTPServer; SimpleHTTPServer.test(SimpleHTTPServer.SimpleHTTPRequestHandler, type('"'"'Server'"'"', (BaseHTTPServer.HTTPServer, SocketServer.ThreadingMixIn, object), {}))" 9090'

# Quick CLI Pasting
alias dsnip="curl -F 'paste=<-' http://s.drk.sc"
alias sprunge="curl -F 'sprunge=<-' http://sprunge.us"


### Application aliases

# SSH / i2ssh aliases
if [ -s "$(which ssh)" ]; then
  alias s=$(which ssh)
fi

if [ -s "$(which i2ssh 2>/dev/null)" ]; then
  alias i=$(which i2ssh)
fi

# Arch-Linux shortcuts
psearch() {
  pacman -Ss $* | egrep -v '^\s+' | cut -d'/' -f2 | cut -d' ' -f1 | ccze -A
}

# Debian/Ubuntu shortcuts
if [ -s "$(which apt-get 2>/dev/null)" ]; then
  alias agu='sudo apt-get update; sudo apt-get upgrade -y'
  alias agi='sudo apt-get install'
  alias acs='sudo apt-cache search'
  alias acp='sudo apt-cache policy'
fi

# Git aliases
if [ -s "$(which git)" ]; then
  alias gpr='git pull --rebase'
  alias gb='git branch'
  alias gp='git push'
  alias gct='git checkout'
  alias gcm='git commit'
  alias gd='git diff'
  alias gds='git diff --staged'
  alias gs='git status'
  alias gsu='git status -uno'
  alias gg='git grep'
  alias glo='git log --oneline'
  alias gc='git checkout master ; git pull --rebase upstream master ; git push origin master'
  alias gscpp="git stash ; git checkout master ; git pull --rebase upstream master ; git push origin master"
  alias gcpp="git checkout master ; git pull --rebase upstream master ; git push origin master"
  alias gdsnip='git diff | dsnip'
fi

# Vagrant aliases
VAGRANT="$(which vagrant 2>/dev/null)"
if [ -s "${VAGRANT}" ]; then

  # Vagrant status / Vagrant ssh
  vs() {
    if [ $# -gt 0 ]; then
      ${VAGRANT} ssh ${*}
    else
      ${VAGRANT} status
    fi
  }

  alias v="${VAGRANT}"
  alias vu="${VAGRANT} up"
  alias vup="${VAGRANT} up --provision"
  alias vp="${VAGRANT} provision"
fi

# Test-kitchen aliases
## All "kci*" aliases assume that a valid API key
## is present in your env() as ${LINODE_API_KEY}.
TEST_KITCHEN="$(which kitchen 2>/dev/null)"
if [ -s "${TEST_KITCHEN}" ]; then

  # Kitchen login/list
  kl() {
    if [ $# -gt 0 ]; then
      ${TEST_KITCHEN} login ${*}
    else
      ${TEST_KITCHEN} list
    fi
  }

  kcil() {
    if [ $# -gt 0 ]; then
      KITCHEN_YML='./.kitchen-ci.yml' ${TEST_KITCHEN} login ${*}
    else
      KITCHEN_YML='./.kitchen-ci.yml' ${TEST_KITCHEN} list
    fi
  }

  alias kt="${TEST_KITCHEN} test"
  alias kv="${TEST_KITCHEN} verify"
  alias kc="${TEST_KITCHEN} converge"
  alias kd="${TEST_KITCHEN} destroy"
  alias ke="${TEST_KITCHEN} exec"

  alias kci="KITCHEN_YML='./.kitchen-ci.yml' ${TEST_KITCHEN}"
  alias kcit="KITCHEN_YML='./.kitchen-ci.yml' ${TEST_KITCHEN} test"
  alias kciv="KITCHEN_YML='./.kitchen-ci.yml' ${TEST_KITCHEN} verify"
  alias kcic="KITCHEN_YML='./.kitchen-ci.yml' ${TEST_KITCHEN} converge"
  alias kcid="KITCHEN_YML='./.kitchen-ci.yml' ${TEST_KITCHEN} destroy"
  alias kcie="KITCHEN_YML='./.kitchen-ci.yml' ${TEST_KITCHEN} exec"
fi

# VirtualBox aliasing
VBOXMAN="$(which VBoxManage 2>/dev/null)"
if [ -s "${VBOXMAX}" ]; then
  echo "Enabling vboxmanage"
  alias vbm="${VBOXMAN}"
  alias vbmm="${VBOXMAN} modifyvm"
  alias vbmc="${VBOXMAN} controlvm"
  alias vbms="${VBOXMAN} startvm"
fi


### Arbitrary functions

# Alert for long running cmds. Usage: sleep 1; alert
if [ -s "$(which say 2>/dev/null)" ]; then
  alias alert="say $*"
else
  alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1| sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
fi

alias ialert='i3-nagbar -m "[$?] Job Completed ($( echo -n $( history | tail -n2 | head -n1 | cut -d\  -f 4- ) )")'

snotify() {
  # Slack notifications from cli via webhook
  PAYLOAD="{ 'text' : '${*}' }"
  if [ ! -z "${SLACK_NOTIFY_HOOK}" ]; then
    curl -X POST -H 'Content-type: application/json' \
         --data "${PAYLOAD}" ${SLACK_NOTIFY_HOOK}
  else
    echo "No webhook was defined in env['SLACK_NOTIFY_HOOK'], I usually put this in my ~/.localrc."
  fi
}

# build single csv string from \n delimited file
csv() {
  if [ $# -eq 1 ]; then
    while read line; do
      echo "'${line}'"
    done < $1 | tr '\n' ','
  fi
}


# Break elfs into opcodes
disas() {
  GCC="$(which gcc 2>/dev/null)"
  if [ -s "${GCC}" ]; then
	   ${GCC} -pipe -S -o - -O -g $* | as -aldh -o /dev/null
  else
     echo "GCC is not installed"
  fi
}

# Create Directory and Change Into It
cmkdir() {
	mkdir -p $*
	cd $*
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

# Track how long it takes to clone or update a repo
gittime() {
  #
  # Parameters: ( params prefixed with * are required arguments )
  # * source  - repository source (git@github.com:scub/deploy-playground.git)
  #   dest    - destination to clone repository to
  #   verbose - report on more than just runtime
  #
  SOURCE=${1}
  DEST=${2}
  VERBOSE=${3}

  # If no destination is provided infer what destination we will clone to
  test -z "${DEST}" && DEST=$(echo ${SOURCE} | cut -d'/' -f2 | cut -d'.' -f1)

  # Check to see if we should say things about what were going to do
  if [ ! -z "${VERBOSE}" ]; then
    echo -n 'Triggering '
    test -d  ${DEST} && echo -n "update " || echo -n "clone "
    echo -n "from source: ${SOURCE} to ${DEST}"
    test -z "${VERBOSE}" && echo "without verbosity" || echo "with increased verbosity."
  fi

  if [ ! -d "${DEST}" ]; then
    RESULTS=$( { time git clone ${SOURCE} ${DEST}; } 2>&1 )
  else
    pushd "${DEST}" 2>/dev/null
    RESULTS=$( { time git pull --rebase origin master; } 2>&1 )
    popd 2>/dev/null
  fi

  # Parse run-time from results (real)
  RUNTIME=$(echo $RESULTS | egrep -i 'real' | awk -F 'real ' '{ print $2 }' | cut -d' ' -f1 )

  if [ ! -z "${VERBOSE}" ]; then
    echo -e "Full results:\n============\n\n${RESULTS}"
    echo -e "============\n\n"
  fi

  echo -n "Runtime: ${RUNTIME}"
}


### If our PS1 builder is alive, lets use it!
test -L ${HOME}/.local.ps1 && source ${HOME}/.local.ps1
