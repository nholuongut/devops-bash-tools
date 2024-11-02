#!/usr/bin/env bash
# shellcheck disable=SC2230
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=lib/utils.sh
. "$srcdir/lib/utils.sh"

yamls="$(find "${1:-.}" -name .gitlab-ci.yml)"

if [ -z "$yamls" ]; then
    return 0 &>/dev/null || :
    exit 0
fi

section "GitLab CI Yaml Lint Check"

if [ -z "${GITLAB_TOKEN:-}" ]; then
    echo "WARNING: \$GITLAB_TOKEN not found in environment and this API endpoint now requires authentication, skipping..." >&2
    exit 0
fi

start_time="$(start_timer)"

while read -r yaml; do
    printf 'Validating %s:\t' "$yaml"
    "$srcdir/../gitlab/gitlab_validate_ci_yaml.sh" "$yaml"
done <<< "$yamls"

time_taken "$start_time"
section2 "GitLab CI yaml validation succeeded"
echo
