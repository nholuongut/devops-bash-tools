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
Generates a Git log of any empty commits

Useful to detect if there are empty commits in Git history

This happens when rewriting Git history with filtering, such as forking a git repo and running 'git filter-branch' but forgetting to include the --prune-empty switch
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args=""

for sha in $(git rev-list --min-parents=1 --max-parents=1 --all); do
    if [ "$(git rev-parse "${sha}^{tree}")" = "$(git rev-parse "${sha}^1^{tree}")" ]; then
        # same output as git log -p -1
        #git show "$sha"
        #git log -p -1 --graph "$sha"
        # only hash and subject, not enough info
        #git log --oneline "$sha"
        #git log -1 --format='%h | %ai | %an | %s' "$sha" | column -t -s '|' || break
        git show --format='%h | %ai | %an | %s' "$sha" | column -t -s '|' || break
    fi
done
