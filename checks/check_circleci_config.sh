#!/usr/bin/env bash
# shellcheck disable=SC2230
#  vim:ts=4:sts=4:sw=4:et

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=lib/utils.sh
. "$srcdir/lib/utils.sh"

# shellcheck source=lib/docker.sh
. "$srcdir/lib/docker.sh"

#return 0 &>/dev/null || :
#exit 0

section "Circle CI Yaml Lint Check"

start_time="$(start_timer)"

#if is_travis; then
#    echo "Running inside Circle CI, skipping lint check"
if is_inside_docker; then
    echo "Running inside Docker, skipping Circle lint check"
else
    if type -P circleci &>/dev/null; then
        type -P circleci
        printf "version: "
        circleci version
        echo
        find . -path '*/.circleci/config.yml' |
        while read -r config; do
            timestamp "checking CircleCI config: $config"
            circleci config validate "$config"
            echo >&2
        done
    else
        echo "WARNING: skipping Circle check as circleci command not found in \$PATH ($PATH)"
    fi
fi

echo
time_taken "$start_time"
section2 "Circle CI yaml validation succeeded"
echo
