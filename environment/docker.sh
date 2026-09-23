#
# Fully clean all docker assets
#
dclean() {
  # Stop all running containers
  docker ps | tail -n+2 | awk '{ print $NF }' | xargs -n1 docker stop
  # Remove all containers
  docker ps -a | tail -n+2 | awk '{ print $NF }' | xargs -n1 docker rm
  # Prune all volumes
  docker volume prune -f
  # Prune all images
  docker image prune -f
  # Prune all networks
  docker network prune -f
}

# Stop any running containers
alias dstop="docker ps | tail -n+2 | awk '{ print $NF }' | xargs -n1 docker stop"