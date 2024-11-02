#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034
usage_description="
Triggers BuildKite build jobs for all pipelines in the \$BUILDKITE_ORGANIZATION
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<curl_options>]"

help_usage "$@"

"$srcdir/buildkite_pipelines.sh" |
while read -r pipeline; do
    echo "triggering job for pipeline '$pipeline'"
    "$srcdir/buildkite_trigger.sh" "$pipeline" > /dev/null
done
