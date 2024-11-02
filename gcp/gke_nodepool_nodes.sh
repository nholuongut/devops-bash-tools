#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Lists all Kubernetes nodes for a given nodepool on the current GKE cluster by filtering for the corresponding label

Requires kubectl to be installed and configured

If you run this on a non-GKE cluster, will return no nodes as there will be no nodes with the matching labels
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="<node_pool_name>"

help_usage "$@"

min_args 1 "$@"

node_pool="$1"

kubectl get nodes -l cloud.google.com/gke-nodepool="$node_pool" -o name
