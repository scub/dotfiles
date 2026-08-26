# 1Password to environment exporter
hydrate() {
  ITEM=$(secret get ONEP_ENV_ITEM)
  VAULT_NAME=$(secret get ONEP_VAULT)

	usage="USAGE: $(basename "$0") [-v|--vault] <vault> [-i|--item] <item> <section>

	where:
	    -h | --help         show this help text
	    -i | --item         1password item to export from vault
	    -v | --vault        1password vault to export secrets from"

	while [ $# -gt 0 ]; do
	    if [[ $1 =~ "--"* ]]; then
	        case $1 in
	            --help|-h) echo "$usage";;
	            --item|-i) ITEM=$2; shift;;
	            --vault|-v) VAULT_NAME=$2; shift;;
	        esac
	    else
	      SECTION=$(echo -n $1 | tr '[:upper:]' '[:lower:]')
	    fi
	    shift
	done

  declare -a CREDS=()

  if [ ! -z $SECTION ]; then
    echo "Hydrating environment for: $SECTION"
    while read line; do
      CREDS+=($line)
    done < <(op item get "$ITEM" --vault $VAULT_NAME --format json | jq --arg section $SECTION -r '.fields[] | select(.section.label == $section)  | "\(.label)=\(.value)"')
  else
    echo "Hydrating all items"
    while read line; do
      CREDS+=($line)
    done < <(op item get "$ITEM" --vault $VAULT_NAME --format json | jq -r '.fields[] | select(.label != "notesPlain") | "\(.label)=\(.value)"')
  fi

  if [ ${#CREDS[@]} -gt 0 ]; then
    for item in ${CREDS[@]}; do
      export item
    done
  fi
}
