github_latest_release() {
    OWNER=$1
    REPO=$2

    which curl jq >/dev/null || {
        echo "[!] Both 'curl' and 'jq' are required to run this tool. Not able to find them in PATH"
        return
    }

    if [[ -z "$1" ]] || [[ -z "$2" ]]; then
        echo "ERROR[api_github_release]: Both an owner and repo are required as positional arguments" >&2
        return 1
    fi

    LATEST_RELEASE=$(curl -sL \
                        -H "Accept: application/vnd.github+json" \
                        -H "X-GitHub-Api-Version: 2026-03-10" \
                        https://api.github.com/repos/$1/$2/releases/latest \
                        | jq -r .tag_name)
    
    echo $LATEST_RELEASE
}
