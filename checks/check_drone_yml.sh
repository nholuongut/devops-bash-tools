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

section "Drone CI Yaml Lint Check"

start_time="$(start_timer)"

#if is_travis; then
#    echo "Running inside Drone CI, skipping lint check"
if is_inside_docker; then
    echo "Running inside Docker, skipping Drone CI yaml lint check"
else
    if type -P drone &>/dev/null; then
        type -P drone
        drone --version
        echo
        if is_CI; then
            echo "using drone from location: $(type -P drone)"
            set +e
        fi
        find . -name '.drone.yml' |
        while read -r drone_yml; do
            echo -n "Validating $drone_yml => "
            drone lint "$drone_yml"
            echo "OK"
        done
        set -e
    else
        echo "WARNING: skipping Drone CI yaml check as 'drone' command not found in \$PATH ($PATH)"
    fi
fi

echo
time_taken "$start_time"
section2 "Drone CI yaml validation succeeded"
echo
