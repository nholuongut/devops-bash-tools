#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


# https://buildkite.com/docs/apis/rest-api/builds

# https://buildkite.com/docs/apis/rest-api/jobs

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_description="
Triggers job retries jobs within builds where Failed status was due to a dead or timed out agent, using the BuildKite API

This is slightly better than retrying the failed builds because it restarts those builds from point of agent failure and replaces the Failed status with the real final status

Really BuildKite should auto-retry in this scenario, which can be configured but is not the default, and this script is a quick workaround to retry failed jobs

https://forum.buildkite.community/t/reschedule-builds-on-other-agents-rather-than-fail-builds-when-agents-time-out-or-are-killed-machine-shut-down-or-put-to-sleep/1388

Can optionally specify a pipeline to retry only failed jobs in builds for that pipeline
"

# shellcheck disable=SC2034
usage_args="[<pipeline>]"

help_usage "$@"

pipeline="${1:-}"

url_path="/builds"

if [ -n "$pipeline" ]; then
    url_path="/{organization}/pipelines/$pipeline/builds"
fi

"$srcdir/buildkite_api.sh" "$url_path" |
jq -r '.[] |
       select(.state == "failed") |
       select(.jobs[].exit_status == -1) |
       [.number, (.jobs[] | (select(.exit_status == -1) | .id)), .pipeline.slug ] |
       @tsv' |
while read -r build_number job_id pipeline_slug; do
    timestamp "retrying '$pipeline_slug' build '$build_number' job '$job_id'"
    "$srcdir/buildkite_api.sh" "/organizations/{organization}/pipelines/$pipeline_slug/builds/$build_number/jobs/$job_id/retry" -X PUT >/dev/null
done
