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
List important Kubernetes pods with their nodes to check on if they are obeying the scheduling requirements you want
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args=""

help_usage "$@"

important_pods_regex="
kube-dns
ingress-nginx
nginx-ingress
cert-manager
jenkins
teamcity
-[[:digit:]]+$
"

important_pods_regex="$(sed '/^[[:space:]]*$/d' <<< "$important_pods_regex" | tr '\n' '|')"
important_pods_regex="${important_pods_regex%|}"

kubectl get pods --all-namespaces -o wide |
grep -Ei "$important_pods_regex"
