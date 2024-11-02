#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Downloads all Jenkins job configs to files of the same name in the current directory via the Jenkins API

Tested on Jenkins 2.319

Uses the adjacent jenkins_api.sh - see there for authentication details
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args=""

help_usage "$@"

timestamp "Downloading all Jenkins job configs to current directory: $PWD"

"$srcdir/jenkins_foreach_job.sh" "
    '$srcdir/jenkins_job_config.sh' '{job}' > '{job}.xml' &&
    echo 'Downloaded config to file: $PWD/{job}.xml'
    "
