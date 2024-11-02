#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/kubernetes.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Taints/untaints all nodes in the given GKE nodepool on the current cluster with your taint spec

See:

    kubectl taint nodes --help

for the taint spec

This is just slightly easier than typing:

    kubectl taint nodes -l cloud.google.com/gke-nodepool=<node_pool_name> ...
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="<node_pool_name> <taint_spec>"

help_usage "$@"

num_args 2 "$@"

node_pool="$1"
shift || :

#kube_config_isolate

#nodes="$(VERBOSE=1 "$srcdir/gke_nodepool_nodes.sh" "$node_pool")"

kubectl taint nodes -l cloud.google.com/gke-nodepool="$node_pool" "$@"
