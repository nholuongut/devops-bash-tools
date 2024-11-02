#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et

# ============================================================================ #
#                               T r a v i s   C I
# ============================================================================ #

# Travis bash autocomplete
# adapted from Travis ruby gem auto-added to end of ~/.bashrc
# shellcheck disable=SC1090,SC1091
#[ -f ~/.travis/travis.sh ] && source ~/.travis/travis.sh

bash_tools="${bash_tools:-$(dirname "${BASH_SOURCE[0]}")/..}"

type git_repo &>/dev/null || . "$bash_tools/.bash.d/git.sh"
type browse &>/dev/null || . "$bash_tools/.bash.d/network.sh"

alias trav='travis_browse'

travis_browse(){
    local repo
    repo="$(github_repo)"
    url="https://travis-ci.org/${TRAVIS_USER:-${USER:-$(whoami)}}/$repo"
    browser "$url"
}

# for auto authentication using Travis CI tools like travis_last_log.py and travis_debug_session.py
#export TRAVIS_TOKEN=...

travis_debug(){
    # code has better automatic handling, doesn't need this now
    #if grep '/' <<< "$1" &>/dev/null; then
    #    travis_debug_session.py -r "$1" ${@:2}
    #else
    #    travis_debug_session.py -J "$1" ${@:2}
    #fi
    opts=()
    if [[ "$PWD" =~ /github/ ]]; then
        local repo
        repo="$(git_repo)"
        if [ -n "$repo" ]; then
            opts+=(--repo "$repo")
        fi
    fi
    travis_debug_session.py "${opts[@]}" "$@"
}

travis_log(){
    local repo
    repo="$(git_repo)"
    travis_last_log.py --failed "$repo" "$@"
}
