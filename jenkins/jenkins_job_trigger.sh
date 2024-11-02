#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et

# https://wiki.jenkins-ci.org/display/JENKINS/Remote+access+API

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Triggers a Jenkins build job via the Jenkins API

The Jenkins job configuration option 'Trigger builds remotely (e.g., from scripts)' can be used to generate a token just for this job/pipeline, or you can use your personal API token

Tested on Jenkins 2.319

Uses the adjacent jenkins_api.sh - see there for authentication details
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="<job_name> [<curl_options>]"

help_usage "$@"

min_args 1 "$@"

job="$1"
shift || :

"$srcdir/jenkins_api.sh" "/job/$job/build?cause=Triggered by ${0##*/}" -X POST "$@"
timestamp "Triggered Jenkins job '$job'"
