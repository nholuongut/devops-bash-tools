#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#  args: echo account id = {id} and name = "{name}"


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Run a command against each Cloudflare account

All arguments become the command template

WARNING: do not run any command reading from standard input, otherwise it will consume the account id/names and exit after the first iteration

The command template replaces the following for convenience in each iteration:

{id}   - with the account id   <-- this is the one you want for chaining API queries with cloudflare_api.sh
{name} - with the account name

eg.
    ${0##*/} 'echo account id = {id} and name = {name}'
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="<command> <args>"

help_usage "$@"

min_args 1 "$@"

"$srcdir/cloudflare_api.sh" accounts |
jq -r '.result[] | [.id, .name] | @tsv' |
sed "s/'/\\\\'/g" |
while read -r account_id account_name; do
    if [ -z "${NO_HEADING:-}" ]; then
        echo "# ============================================================================ #" >&2
        echo "# $account_id - $account_name" >&2
        echo "# ============================================================================ #" >&2
    fi
    cmd=("$@")
    cmd=("${cmd[@]//\{account_id\}/$account_id}")
    cmd=("${cmd[@]//\{account_name\}/$account_name}")
    cmd=("${cmd[@]//\{id\}/$account_id}")
    cmd=("${cmd[@]//\{name\}/$account_name}")
    # need eval'ing to able to inline quoted script
    # shellcheck disable=SC2294
    eval "${cmd[@]}"
done
