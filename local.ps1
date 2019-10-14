#!/bin/bash


####
###
## Quick behavior definitions
###
####
AWS_IDENTITY_TIMEOUT=10s
AWS_REMOVE_LOCKOUT=300

####
###
## Quick Color Definitions
###
####
export RED="\033[31m"
export DARK_YELLOW="\033[33m"
export CYAN="\033[36m"
export BLUE="\033[34m"
export MAGENTA="\033[35m"
export ORANGE="\033[91m"
export CLEAR="\033[0m"

####
###
## PS1 Preamble/Conclusion
###
####
ps1_prefix() {
  OLDRETVAL=$?
  echo "$(ps1_get_host_identity) - $(ps1_get_python_venv)"
  exit ${OLDRETVAL}
}

ps1_finalize() {
  OLDRETVAL=$?
  echo -en  "\n   ${RED}|___ ${CYAN}$ ${CLEAR}"
  exit ${OLDRETVAL}
}


####
###
## Exit code reactions: Require UTF8 support
###
####

# Emoji listing
export HAPMOJI=("¯\_(ツ)_/¯" "ʕᵔᴥᵔʔ" "ヽ(´ー｀)ノ" "☜(⌒▽⌒)☞" "( ͡° ͜ʖ ͡°)" "(づ￣ ³￣)づ" "◔_◔" "ԅ(≖‿≖ԅ)" "{•̃_•̃}" "(∩｀-´)⊃━☆ﾟ.*･｡ﾟ" "(っ▀¯▀)" "ヽ( •_)ᕗ")
export SADMOJI=("[¬º-°]¬" "(Ծ‸ Ծ)" "(҂◡_◡)" "ミ●﹏☉ミ" "(⊙_◎)" "(´･_･\`)" "(⊙.☉)7" "⊙﹏⊙" "ᕦ(ò_óˇ)ᕤ" "ε=ε=ε=┌(;*´Д\`)ﾉ" "ლ(｀ー´ლ)" "ʕ •\`ᴥ•´ʔ" "ʕノ•ᴥ•ʔノ ︵ ┻━┻")

ps1_reacji() {
  OLDRETVAL=$?
  test ${OLDRETVAL} -eq 0 && \
    echo -e "${BLUE}${HAPMOJI[$(((${RANDOM}%${#HAPMOJI[@]})))]}${CLEAR} (${OLDRETVAL})" || echo -e "${RED}${SADMOJI[$(((${RANDOM}%${#SADMOJI[@]})))]}${CLEAR} (${OLDRETVAL})"
  exit ${OLDRETVAL}
}

ps1_reacji_bear() {
  OLDRETVAL=$?
  test ${OLDRETVAL} -eq 0 && \
    echo -e "${BLUE}ʕ ㅇ ᴥ ㅇʔ${CLEAR} (${OLDRETVAL})" || echo -e "${RED}ʕノ•ᴥ•ʔノ ︵ ┻━┻${CLEAR} (${OLDRETVAL})"
}


####
###
## Environment Probes
###
####

ps1_get_host_identity() {
  OLDRETVAL=$?
  echo -e "${ORANGE}<[${DARK_YELLOW}$(hostname -s)${ORANGE}]>${CLEAR}"
  exit ${OLDRETVAL}
}

ps1_get_python_venv(){
    OLDRETVAL=$?
    if [ ! -z "${VIRTUAL_ENV}" ]; then
        venv_name=$( echo ${VIRTUAL_ENV} | awk -F '/' '{ print $NF }' )
        echo -en "${RED}(${DARK_YELLOW}VENV: ${venv_name}${RED})${CLEAR}"
    fi
    exit ${OLDRETVAL}
}


####
###
## Guest/Container Probes
###
####
ps1_virt_state() {
    OLDRETVAL=$?

    GUESTS=$((($(virsh list | tail -n+3 | wc -l)-1)))
    CONTAINERS=$(docker ps | tail -n+2 | wc -l)
    echo -en "\n   ${RED}|-- [ ${CYAN}Virtual ${RED}Guests: ${DARK_YELLOW}${GUESTS} ${RED}Containers: ${DARK_YELLOW}${CONTAINERS} ${RED}]${CLEAR}"

    exit ${OLDRETVAL}
}

####
###
## Git Probes
###
####

ps1_git_info() {
  OLDRETVAL=$?
  if [[ -d ${PWD}/.git ]]; then
    echo -en "\n   ${RED}|-- ${CYAN}${ORANGE}[ Project: ${DARK_YELLOW}$(pwd | awk -F '/' '{print $NF}') "
    echo -en "${RED}|| Branch: ${DARK_YELLOW}$(ps1_git_branch) "
    echo -en "${RED}|| ${ORANGE} Commit: ${DARK_YELLOW}$(ps1_git_commit) ${RED}]${CLEAR}"
  else
    echo -en ""
  fi
  exit ${OLDRETVAL}
}

# Grab current branch git branch if applicable
ps1_git_branch() {
  BRANCH=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/' || echo 'N/A')
  echo "${BRANCH}" | tr -d ' ' | tr -d '(' | tr -d ')'
}

# Grab current git commit
ps1_git_commit() {
  CUR_COMMIT="$(git log --pretty=format:'%h' -n 1 2> /dev/null || echo '')"
  test -z "${CUR_COMMIT}" && echo "unidentified" || echo -en "${CUR_COMMIT}" | tr -d ' '
}

####
###
## External resources (require networking) - using local cache with inotify is recommended
###
####

# GET LIST OF ALL REMOTE IDENTITIES
ps1_get_remote_ids(){
  OLDRETVAL=$?
  echo "$(ps1_aws_identity)"
  exit ${OLDRETVAL}
}

ps1_aws_identity() {
  OLDRETVAL=$?

  ## If this is our initial session flush our cache
  #[[ $(cat ${CNT_FD}) -eq 0 ]] && rm -f ${AWS_IDENTITY_CACHE}

  ## Flush cache each time we hit a random number
  ## divisible by the answer to the universe (42).
  #if [[ ${RANDOM}%42 -eq 0 ]]; then
  #  CNT=$(($(cat ${CNT_FD})+1))
  #  echo ${CNT} > ${CNT_FD}
  #  echo "Hit #${CNT} on 42"
  #  rm -f ${AWS_IDENTITY_CACHE}
  #fi

  # Read from cache when available - needs to be invalidated
  if [[ ! -e ${AWS_IDENTITY_LOCK} ]]; then
    if [[ ! -e ${AWS_IDENTITY_CACHE} ]]; then
      # Can only check if were online, naive verify (do we have any routes?)
      if [[ $(ip r | wc -l) -gt 0 ]]; then
        # Check if credentials are available
        if [[ -e "${HOME}/.aws/config" ]]; then
  
          IDENTITY_BLOB=$( timeout ${AWS_IDENTITY_TIMEOUT} aws sts get-caller-identity 2>/dev/null || touch ${AWS_IDENTITY_LOCK} )
          if [[ ! -z "${IDENTITY_BLOB}" ]]; then
            # Pull what we need from the IDENTITY_BLOB
            echo ${IDENTITY_BLOB} | jq -M '.Arn' | tr -d '"' | tr -d ' ' > ${AWS_IDENTITY_CACHE}
          else
            # Grab a timeout lock if we got a null result
            touch ${AWS_IDENTITY_LOCK}
          fi
        fi
      fi
    fi
  
    IDENTITY=$((cat ${AWS_IDENTITY_CACHE} 2>/dev/null || echo "") | tr -d '\n')
    if [[ -z "${IDENTITY}" ]]; then
      rm -f ${AWS_IDENTITY_CACHE}
    else
      echo -en "\n   ${RED}|-- [ AWS User: ${DARK_YELLOW}${IDENTITY}${RED} ]"
    fi
  else
    if [[ ! -e ${AWS_IDENTITY_LOCK} ]]; then
      touch ${AWS_IDENTITY_LOCK}
    else
      # Check for stale lockout - defined as a global at the top of our script 
      # remove after we consider it a long enough time to retry our identity checks.
      LOCK_EPOCH=$(date +%s -r ${AWS_IDENTITY_LOCK})
      LOCK_LIFESPAN=$((( $(date +%s) - ${LOCK_EPOCH} )))

      echo "AWS: LOCK_EPOCH: ${LOCK_EPOCH} LOCK_LIFESPAN: ${LOCK_LIFESPAN}" >> /tmp/ps1-debug.log
      [[ ${LOCK_LIFESPAN} -gt ${AWS_REMOVE_LOCKOUT} ]] && \
        rm -f ${AWS_IDENTITY_LOCK}
        echo "AWS Id lockout expired, rechecking" >> /tmp/ps1-debug.log
    fi
  fi

  exit ${OLDRETVAL}
}

### SETUP OUR PS1 ONCE AND FOR ALL
  export PS1='$(ps1_prefix) \w $(ps1_virt_state) $(ps1_get_remote_ids) $(ps1_git_info) $(ps1_finalize)'
