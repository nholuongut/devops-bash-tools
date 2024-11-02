#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Downloads all Jenkins job configs to files of the same name in the current directory via the Jenkins CLI

Tested on Jenkins 2.319

Uses the adjacent jenkins_cli.sh - see there for authentication details
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args=""

help_usage "$@"

timestamp "Downloading all Jenkins job configs to current directory: $PWD"

# something in jenkins_cli.sh is causing the loop to terminate early with no more lines
"$srcdir/jenkins_foreach_job_cli.sh" "
    '$srcdir/jenkins_cli.sh' get-job '{job}' </dev/null > '{job}.xml' &&
    echo >> '{job}.xml' &&
    echo 'Downloaded config to file: $PWD/{job}.xml'
    "
