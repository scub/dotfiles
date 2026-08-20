# ---------------------------------------------------------------------------- #
#                                   TELEPORT                                   #
# ---------------------------------------------------------------------------- #

#
# Teleport CLI auto-login and auto-update functions
#

# Function: get-teleport-version
# Description: Retrieves the version of Teleport for the specified component (server or client).
# Parameters:
#   - component: The component for which to retrieve the version (server or client).
# Returns:
#   - The version of the specified component.
get-teleport-version() {
  local component="$1"
  local response
  local version

  TELEPORT_ENTRY=$(secret get TELEPORT_ENTRY 2>/dev/null)
  
  if [ "$component" = "server" ]; then
    # this is a public endpoint, so no auth is required
    response=$(curl -s https://$TELEPORT_ENTRY/webapi/ping)
    version=$(echo "$response" | jq -r '.server_version')
  elif [ "$component" = "client" ]; then
    if command -v tsh >/dev/null 2>&1; then
      # if we're not authenticated we can still retrieve the client version
      version=$(tsh version --client -f json | jq -r ".version")
    else
      version="n/a"
    fi
  else
    echo "Error: Invalid component specified. Please specify 'client' or 'server'."
    return 1
  fi
  
  if [ -z "$version" ]; then
    echo "Error: Failed to retrieve the $component version."
    return 1
  fi
  
  echo "$version"
}

# Function: install-teleport
# Description: Downloads and installs a specific version of Teleport Enterprise.
# Parameters:
#   - version: The version of Teleport Enterprise to install.
# Returns:
#   - None.
install-teleport() {
  local version=${1}
    local url="https://cdn.teleport.dev/teleport-ent-${version}.pkg"
    local pkg="teleport-ent-${version}.pkg"
    
    # Download the package
    if ! curl -o ${pkg} ${url}; then
      echo "Error: Failed to download the package."
      rm ${pkg}  # Cleanup the downloaded package
      return 1
    fi
    
    # Install the package
    if ! sudo installer -pkg ${pkg} -target /; then
      echo "Error: Failed to install the package."
      rm ${pkg}  # Cleanup the downloaded package
      return 1
    fi
    
    echo "Teleport ${version} installed successfully."
    
    # Cleanup the downloaded package
    rm ${pkg}
}

# Function: update-teleport-client
# Description: Updates the Teleport client to match the version of the Teleport server.
# Parameters:
#   - None.
# Returns:
#   - None.
update-teleport-client() {
  local server_version=$(get-teleport-version server)
  local client_version=$(get-teleport-version client)
  if [ "${server_version}" != "${client_version}" ]; then
    echo "Server version: ${server_version}"
    echo "Client version: ${client_version}"
    echo "Updating teleport client to server version"
    install-teleport ${server_version}
  else
    echo "Teleport client is up to date"
  fi
}

# Check if there is an active session, then check for updates to the client
# Install the latest client and then login
function tsh-update-and-login () {
  TELEPORT_ENTRY=$(secret get TELEPORT_ENTRY 2>/dev/null)

  if ! tsh status > /dev/null 2>&1
  then
    update-teleport-client
    echo "No active session. Logging you in first by running 'tsh --proxy https://$TELEPORT_ENTRY --auth okta login'..."
    tsh --proxy https://$TELEPORT_ENTRY --auth okta login
  fi
}

# Quickly request elevated privileges in whatever enironment you need.
function tshrequest() {
  if [ $# -le 1 ]
  then
    echo "Need an Environment and a JIRA Ticket"
    echo "Example: tshrequest staging ATM-123"
    return 0
  fi
  tsh request create --roles developer-$1-privileged --reason "'$2'"
}

#
# Teleport CLI user and group search functions
#

teleusersearch() {
  if [ -z "$1" ]; then
    echo "Usage: teleusersearch <partial-name>"
    return 0
  fi

  # Regex substring match (test)
  tctl get users --format=json | jq -r --arg u "$1" \
    '.[] | select(.metadata.name | test($u; "i")) | .metadata.name'
}

teleusergroups() {
  if [ -z "$1" ]; then
    echo "Usage: teleusergroups [-a] <user-name>"
    echo "  -a : Show all groups (Default: only shows 'exp_' groups)"
    return 0
  fi

  if [ "$1" = "-a" ]; then
    USER_NAME="$2"
    JQ_FILTER='.spec.traits.groups'
  else
    USER_NAME="$1"
    JQ_FILTER='.spec.traits.groups | map(select(test("^exp_"; "i")))'
  fi

  tctl get users --format=json | jq -r --arg u "$USER_NAME" \
    '.[] | select((.metadata.name | ascii_downcase) == ($u | ascii_downcase)) | .metadata.name, "---", ('"$JQ_FILTER"' | sort | .[])'
}

telegroupmembers() {
  if [ -z "$1" ]; then
    echo "Usage: telegroupmembers <group-name>"
    echo "Examples:"
    echo "  telegroupmembers <group_name>"
    echo "  telegroupmembers 'North America'"
    return 0
  fi

  tctl get users --format=json | jq -r --arg g "$1" \
    '.[] | select(.spec.traits.groups // [] | map(ascii_downcase) | any(. == ($g | ascii_downcase))) | .metadata.name'
}

#
# Teleport CLI shell aliases
#

# Okta auth into Teleport
alias tshlogin=tsh-update-and-login

# And an alias to revoke those privileges from yourself whenever you're done.
alias tshrevoke='tsh request drop'