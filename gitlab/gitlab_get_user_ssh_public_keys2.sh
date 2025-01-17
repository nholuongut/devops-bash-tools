#!/usr/bin/env bash

# https://docs.gitlab.com/ee/api/users.html#list-ssh-keys

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x

usage(){
    cat <<EOF
Fetches a GitLab user's public SSH key(s) via HTTP

User can be given as first argument, or environment variables \$GITLAB_USER or \$USER

Technically should use the GitLab API, see instead:  gitlab_ssh_get_user_public_keys.sh

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
elif [ -n "${GITLAB_USER:-}" ]; then
    user="$GITLAB_USER"
elif [ -n "${USER:-}" ]; then
    if [[ "$USER" =~ nholuongut|nho ]]; then
        user=nholuongut
    else
        user="$USER"
    fi
else
    usage
fi


echo "# Fetching SSH Public Key(s) from GitLab for account:  $user" >&2
echo "#" >&2
curl -sS --fail "https://gitlab.com/$user.keys"
