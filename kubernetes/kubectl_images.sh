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
Lists Kubernetes container images running on the current cluster

Requires kubectl to be in \$PATH and configured
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args=""

help_usage "$@"

# some similar queries:
#
# https://kubernetes.io/docs/tasks/access-application-cluster/list-all-running-container-images/

kubectl get pods --all-namespaces --field-selector status.phase=Running -o jsonpath='{range .items[*]}{range .spec.containers[*]}{.image}{"\n"}' |
sort -u
