#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Sets the current or given git directory and submodules to be marked as safe

Necessary for some CI/CD systems like Azure DevOps Pipelines which have incorrect ownership on the git checkout dir triggering this error:

    fatal: detected dubious ownership in repository at '/code/sql'
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<dir>]"

help_usage "$@"

#min_args 1 "$@"

# this script is standalone without lib dependency so can be called directly from bootstrapped CI before submodules, since that is the exact problem that needs to be solved to allow CI/CD systems with incorrect ownership of the checkout directory to be able to checkout the necessary git submodules
"$srcdir/../setup/ci_git_set_dir_safe.sh" "${1:-.}"
