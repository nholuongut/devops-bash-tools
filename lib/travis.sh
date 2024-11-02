#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
libdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090
. "$libdir/git.sh"

get_travis_user(){
    "$libdir/../travis_api.sh" /user | jq -r '.login'
}

travis_prefix_repo(){
    local repo="$1"
    local user
    if ! [[ "$repo" =~ /|%2F ]]; then
        user="$(get_travis_user)"
        repo="$user/$repo"
    fi
    echo "$repo"
}

travis_url_encode_repo(){
    local repo="$1"
    repo="${repo//\//%2F}"
    echo "$repo"
}

travis_prefix_encode_repo(){
    local repo="${1:-}"
    if [ -z "$repo" ]; then
        repo="$(git_repo)"
    fi
    repo="$(travis_prefix_repo "$repo")"
    repo="$(travis_url_encode_repo "$repo")"
    echo "$repo"
}
