# Vagrant status / Vagrant ssh
VAGRANT="$(which vagrant)"

if [ -s "${VAGRANT}" ]; then
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