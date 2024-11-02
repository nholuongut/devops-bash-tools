#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034
usage_description="
Lists BuildKite pipelines in slug format (re-usable in API), one per line to make it easy to iterate on them

eg. trigger a build of each pipeline:

./buildkite_pipelines.sh | while read pipeline; do ./buildkite_trigger.sh \"\$pipeline\"; done
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<curl_options>]"

help_usage "$@"

"$srcdir/buildkite_api.sh" "/organizations/{organization}/pipelines" | jq -r '.[].slug'
