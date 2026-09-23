# Granted
# https://granted.dev/
# Alias to switch profile and populate temporary credentials
sso () {
  if [[ -z $1 ]]
  then
    echo "Usage: sso <profile>"
    return 1
  fi
  if [[ $1 == "new" ]]
  then
    export AWS_PROFILE=
    aws configure sso
    return 0
  else
    source assume $1 --export
    return 0
  fi
}