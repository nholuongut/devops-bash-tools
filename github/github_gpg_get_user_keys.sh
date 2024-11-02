#!/usr/bin/env bash
#

# https://docs.github.com/en/rest/reference/users#list-gpg-keys-for-a-user

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x

usage(){
    cat <<EOF
Fetches a GitHub user's public GPG key(s) via the GitHub API

User can be given as first argument, or environment variables \$GITHUB_USER or \$USER

${0##*/} <user>
EOF
    exit 3
}

for arg; do
    case "$arg" in
        -*)     usage
                ;;
    esac
done

if [ $# -gt 1 ]; then
    usage
elif [ $# -eq 1 ]; then
    user="$1"
elif [ -n "${GITHUB_USER:-}" ]; then
    user="$GITHUB_USER"
elif [ -n "${USER:-}" ]; then
    if [[ "$USER" =~ nholuongut|nho ]]; then
        user=nholuongut
    else
        user="$USER"
    fi
else
    usage
fi

echo "# Fetching GPG Public Key(s) from GitHub for account:  $user" >&2
echo "#" >&2
curl -sS --fail "https://api.github.com/users/$user/gpg_keys" |
jq -r '.[].public_key'
