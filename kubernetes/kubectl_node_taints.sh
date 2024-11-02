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
Lists Kubernetes nodes and their taints, one taint per line

Output Format:

<node_name>     <key>=<value>:<effect>


Requires kubectl to be installed and configured


See Also:

    kubectl_node_labels.sh - list nodes and their labels, one label per line

    kubectl taint nodes -l key=value <taint_spec>
eg.
    kubectl taint nodes -l cloud.google.com/gke-preemptible=true preemptible=true:NoSchedule
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args=""

num_args 0 "$@"

help_usage "$@"

kube_config_isolate

kubectl get nodes -o json |
jq -r '
    .items[] |
    { "name": .metadata.name, "taint": .spec.taints[]? } |
    select(.taint) |
    [ .name, .taint.key + "=" + .taint.value + ":" + .taint.effect ] |
    @tsv
'
