#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=lib/git.sh
. "$srcdir/lib/git.sh"

# For Git < 2.0 may need to set:
#
# git config merge.defaultToUpstream true

foreachbranch 'git fetch && git merge --no-edit && git merge master --no-edit'

git checkout master
