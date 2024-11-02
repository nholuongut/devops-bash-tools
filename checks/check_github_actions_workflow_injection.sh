#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/git.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Checks the GitHub Actions workflows in the given Git repo checkout don't have any obvious script injection risks
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<directory>]"

help_usage "$@"

#min_args 1 "$@"

section "GitHub Actions Script Injection Check"

dir="${1:-.}"

cd "$dir"

git_root="$(git_root)"

workflow_dir="$git_root/.github/workflows"

# false positive
# shellcheck disable=SC2016
if git grep '^[[:space:]]\+run:.*${{' "$workflow_dir/"*.yaml "$workflow_dir/"*.yml; then
    echo
    die "WARNING: possible script injection vectors detected under '$workflow_dir'"
else
    section2 "GitHub Actions script injection check passed"
fi
