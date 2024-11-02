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
Generates the kubeadm join command for an already existing Kubernetes cluster where the initial kubeadm init join command token has already expired

kubeadm is assumed to be working and available in the \$PATH

Tested on Kubernetes 1.18.1
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args=""

help_usage "$@"

#min_args 1 "$@"

token="$(kubeadm token generate)"

kubeadm token create "$token" --ttl 2h --print-join-command
