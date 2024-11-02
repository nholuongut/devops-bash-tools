#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#  args: echo "job='{job}'"
#

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Run a command for each Jenkins Job name obtained via the Jenkins API

All arguments become the command template

WARNING: do not run any command reading from standard input, otherwise it will consume the job names and exit after the first iteration


Uses the adjacent jenkins_api.sh - see there for authentication details

The command template replaces the following for convenience in each iteration:

{job}    => the job name


Tested on Jenkins 2.319


Example:

    ${0##*/} echo \"job='{job}'\"
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="<command> <args>"

help_usage "$@"

min_args 1 "$@"

"$srcdir/jenkins_jobs.sh" |
while read -r job; do
    echo "# ============================================================================ #" >&2
    echo "# $job" >&2
    echo "# ============================================================================ #" >&2
    cmd=("$@")
    cmd=("${cmd[@]//\{job\}/$job}")
    # need eval'ing to able to inline quoted script
    # shellcheck disable=SC2294
    eval "${cmd[@]}"
    echo >&2
done
