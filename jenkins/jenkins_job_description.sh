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
Gets or Sets the description of a given Jenkins job/pipeline via the Jenkins API

Tested on Jenkins 2.319

Uses the adjacent jenkins_api.sh - see there for authentication details
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="<job_name> [<description>]"

help_usage "$@"

min_args 1 "$@"

job="$1"
shift || :
description="$*"

if [ -n "$description" ]; then
    "$srcdir/jenkins_api.sh" "/job/$job/description?description=$description" -X POST
    timestamp "Set Jenkins job '$job' description to '$description'"
else
    "$srcdir/jenkins_api.sh" "/job/$job/description"
    # because there isn't a newline at the end
    echo
fi
