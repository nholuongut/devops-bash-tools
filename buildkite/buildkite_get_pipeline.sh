#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#  args: devops-bash-tools


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034
usage_description="
Fetches a BuildKite pipeline's configuration to stdout

Useful for saving the BuildKite pipeline configuration to a local JSON file

The saved configuration can be loaded via buildkite_create_pipeline.sh

Important: you probably don't want to commit this pipeline.json to a public Git repo because it contains
the webhook URL to triggers builds and could lead to a DoS exploit if publicly disclosed

Used by buildkite_recreate_pipeline.sh to wipe out old history and reset stats
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="<pipeline> [<curl_options>]"

help_usage "$@"

if [ $# -gt 0 ]; then
    pipeline="$1"
    shift
else
    pipeline="${BUILDKITE_PIPELINE:-${PIPELINE:-}}"
fi

if [ -z "$pipeline" ]; then
    usage "\$BUILDKITE_PIPELINE not defined and no argument given"
fi

"$srcdir/buildkite_api.sh" "/organizations/{organization}/pipelines/$pipeline" "$@" | jq .
