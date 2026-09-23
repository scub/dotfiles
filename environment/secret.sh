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

  MODE="$1"
  KEY="$2"
  KIND="shell secret"
  ACCOUNT="$(whoami)"
  ARG_LENGTH="$#"

  # Set a secret in keychain
  if [ "$MODE" = "set" ] && [ $ARG_LENGTH -eq "3" ]; then
    VALUE="$3"
    if security add-generic-password -U -a "$ACCOUNT" -D "$KIND" -s "$KEY" -w "$VALUE";
    then echo "$KEY saved to keychain.";
    fi

  # Get a secret from keychain
  elif [ "$MODE" = "get" ] && [ $ARG_LENGTH -eq "2" ]; then
    security find-generic-password -a "$ACCOUNT" -D "$KIND" -s "$KEY" -w;

  # Export a secret to shell
  elif [ "$MODE" = "export" ] && [ $ARG_LENGTH -ge "2" ]; then
    SILENT=false
    if [[ $* = *--silent* ]]; then SILENT=true; fi
    if security find-generic-password -a "$ACCOUNT" -D "$KIND" -s "$KEY" -w &>/dev/null;
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
    security delete-generic-password -a "$ACCOUNT" -D "$KIND" -s "$KEY" &>/dev/null \
      && echo "Secret $KEY removed"                                                 \
      || echo "Failed to remove secret $KEY"

  # Unkown mode
  else
    echo $USAGE;
  fi
}