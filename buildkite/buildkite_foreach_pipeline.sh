#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_description="
Run a command for each Buildkite pipeline

All arguments become the command template

WARNING: do not run any command reading from standard input, otherwise it will consume the pipeline names and exit after the first iteration

The command template replaces the following for convenience in each iteration:

{organization}          => \$BUILDKITE_ORGANIZATION / \$BUILDKITE_USER
{pipeline}              => the pipeline name

eg.
    ${0##*/} echo user={user} name={name} pipeline={pipeline}
"

# shellcheck disable=SC2034
usage_args="[<command>]"

help_usage "$@"

min_args 1 "$@"

"$srcdir/buildkite_pipelines.sh" |
while read -r pipeline; do
    if [ -n "${NO_HEADING:-}" ]; then
        echo "# ============================================================================ #" >&2
        echo "# $pipeline" >&2
        echo "# ============================================================================ #" >&2
    fi
    cmd=("$@")
    cmd=("${cmd[@]//\{pipeline\}/$pipeline}")
    # need eval'ing to able to inline quoted script
    # shellcheck disable=SC2294
    eval "${cmd[@]}"
done
