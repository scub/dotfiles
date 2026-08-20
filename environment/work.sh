# Retrieve queue information
qinfo() {
  USAGE="
    Usage:
    > qinfo [QUEUE] [ENVIRONMENT] # ENVIRONMENT: staging|production
    > qinfo [QUEUE] # Defaults to staging
  "

  QUEUE=$1
  QENV=${2:-staging}
  QMAN_URL=$(eval echo $(secret get QMAN_URL 2>/dev/null))
  ARG_LENGTH="$#"

  # Unkown mode
  if [ $ARG_LENGTH -ge "1" ]; then
    curl -Lso - $QMAN_URL/$QUEUE | jq .
  else
    echo $USAGE;
  fi
}