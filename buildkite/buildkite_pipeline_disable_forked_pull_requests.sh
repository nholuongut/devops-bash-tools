#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034
usage_description="
Disables Forked Pull Request builds on a BuildKite pipeline to protect your build environment from arbitrary code execution security vulnerabilities

Uses adjacent script buildkite_patch_pipeline.sh
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<pipeline-name> <curl_options>]"

help_usage "$@"

check_env_defined BUILDKITE_ORGANIZATION

pipeline="${1:-${BUILDKITE_PIPELINE:-}}"

if [ -z "$pipeline" ]; then
    usage "\$BUILDKITE_PIPELINE not defined and couldn't be determined from JSON config"
fi

"$srcdir/buildkite_patch_pipeline.sh" "$pipeline" \
'{
  "provider": {
    "settings": {
      "build_pull_request_forks": false
    }
  }
}'
