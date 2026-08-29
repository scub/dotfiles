## Save and export shell secrets using keychain
secret () {
  USAGE="
    Usage:
    > secret set [KEY] [VALUE]
    > secret get [KEY]
    > secret export [KEY] # outputs: export [KEY]=[VALUE]
    > secret export [KEY] --silent # logs only on errors
    > secret unset [KEY]
  "

  export MODE="$1"
  export KEY="$2"
  export ACCOUNT="$(whoami)"
  ARG_LENGTH="$#"

  case $(uname -s) in
    Darwin)
      export KIND="shell secret"
      ADD_SECRET='secret add-generic-password -U -a \"$ACCOUNT\" -D \"$KIND\" -s \"$KEY\" -w \"$VALUE\"'
      GET_SECRET='secret find-generic-password -a \"$ACCOUNT\" -D \"$KIND\" -s \"$KEY\" -w'
      UNSET_SECRET='secret delete-generic-password -a \"$ACCOUNT\" -D \"$KIND\" -s \"$KEY\"'
      ;;
    Linux)
      export KIND="shell"
      ADD_SECRET='echo $VALUE | secret-tool store --label="$KEY" key $KEY account $ACCOUNT kind $KIND'
      GET_SECRET='secret-tool lookup key $KEY account $ACCOUNT kind $KIND'
      UNSET_SECRET='secret-tool clear key $KEY account $ACCOUNT kind $KIND'
      ;;
  esac

  # Set a secret in keychain
  if [ "$MODE" = "set" ] && [ $ARG_LENGTH -eq "3" ]; then
    export VALUE="$3"

    if $(echo "echo $ADD_SECRET" | envsubst);
    then echo "$KEY saved to keychain.";
    fi

  # Get a secret from keychain
  elif [ "$MODE" = "get" ] && [ $ARG_LENGTH -eq "2" ]; then
    $(echo $GET_SECRET | envsubst) || return $?
    # security find-generic-password -a "$ACCOUNT" -D "$KIND" -s "$KEY" -w;

  # Export a secret to shell
  elif [ "$MODE" = "export" ] && [ $ARG_LENGTH -ge "2" ]; then
    SILENT=false
    if [[ $* = *--silent* ]]; then SILENT=true; fi
    if $(echo $GET_SECRET | envsubt) &>/dev/null #security find-generic-password -a "$ACCOUNT" -D "$KIND" -s "$KEY" -w &>/dev/null;
    then
      export $KEY="$(secret get $KEY | xargs)"
      # echo only if --silent is not passed
      if [ "$SILENT" = "false" ]; then
        echo "$KEY loaded from keychain.";
      fi
    else
      echo "$KEY not found in keychain."
    fi

  # Delete a secret in keychain
  elif [ "$MODE" = "unset" ] && [ $ARG_LENGTH -eq "2" ]; then
    # security delete-generic-password -a "$ACCOUNT" -D "$KIND" -s "$KEY" &>/dev/null \
    $(echo $UNSET_SECRET | envsubst)            \
      && echo "Secret $KEY removed"             \
      || echo "Failed to remove secret $KEY"

  # Unkown mode
  else
    echo "$USAGE";
  fi

  for var in MODE KEY KIND ACCOUNT; do
    unset $var
  done
}