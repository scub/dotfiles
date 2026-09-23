# VirtualBox aliasing
VBOXMAN="$(which VBoxManage)"

if [ -s "${VBOXMAX}" ]; then
  alias vbm="${VBOXMAN}"
  alias vbmm="${VBOXMAN} modifyvm"
  alias vbmc="${VBOXMAN} controlvm"
  alias vbms="${VBOXMAN} startvm"
fi