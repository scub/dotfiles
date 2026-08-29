#!/bin/bash
#
#  This is intended to be deployed as a direnv module in ~/.config/direnv/lib/
# and consumed through the use of the projects `.envrc`
#

function bitwarden_password_to_env() {
    if [[ "$#" -lt 2 ]]; then
        echo "You must specify at least one folder and one secret name" >&2
        exit 1
    fi

    folder=$1
    shift

    REFRESH=0
    for environment_variable_name in "$@"; do
        if [ $(env | egrep -c $environment_variable_name) -eq 0 ]; then
            echo "$environment_variable_name was not found, refreshing."; REFRESH=1
        fi
    done

    if [ $REFRESH -eq 1 ]; then
        # If not logged in
        if [[ -z $BW_SESSION ]]; then
            BW_SESSION=$(bw unlock --raw)
            # If login failed
            if [[ -z $BW_SESSION ]]; then
                echo "Failed to login"
                exit 1
            fi
        fi

        FOLDER_ID=$(bw list folders --search "$folder" --session $BW_SESSION | jq -r '.[0].id')
        echo "looking in $FOLDER_ID for passwords $@"

        if [[ -z "$FOLDER_ID" || "$FOLDER_ID" == "null" ]]; then
            echo "Failed to find folder $folder. Check if it exists and sync if necessary"
            exit 1
        fi

        for environment_variable_name in "$@"; do
            CREDS=$(bw list items --folderid $FOLDER_ID --search "$environment_variable_name" --session $BW_SESSION | jq -r '.[0].login.password')
            if [[ -z "$CREDS" || "$CREDS" == "null" ]]; then
                echo "❌️ Failed to retrieve $environment_variable_name in $folder. Check if it exists and sync if necessary." >&2
                exit 1
            fi

            export "$environment_variable_name=$CREDS"
            echo "✅️ Exported $environment_variable_name"
        done
    fi
}