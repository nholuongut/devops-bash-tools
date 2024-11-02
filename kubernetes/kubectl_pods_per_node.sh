#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Gets the number of pods per node sorted descending

Requires kubectl in \$PATH
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<kubectl_options>]"

help_usage "$@"

#kubectl get pods --all-namespaces -o json |
#jq -r '.items[] | .spec.nodeName' |
kubectl get pods --all-namespaces -o jsonpath='{range .items[*]}{.spec.nodeName}{"\n"}' |
sort |
uniq -c |
sort -k1nr
