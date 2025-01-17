#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


# XXX: doesn't install on new M1 Apple chip
#
#   [ERROR]  Can not find systemd or openrc to use as a process supervisor for k3s
#
# GitHub issue:
#
#   https://github.com/k3s-io/k3s/issues/734
#
# Workaround - use k3d instead:
#
#   install_k3d.sh

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/../lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Installs K3s mini kubernetes distribution and adds it to the kubectl config
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args=""

k3s_yaml="/etc/rancher/k3s/k3s.yaml"
kubeconfig="${KUBECONFIG:-~/.kube/config}"

timestamp "Installing K3s"

curl -sfL https://get.k3s.io | sh -

timestamp "Copying $k3s_yaml to $kubeconfig so we can use regular 'kubectl' instead of 'k3s kubectl'"

mkdir -pv "$(dirname "$kubeconfig")"

cat "$k3s_yaml" >> "$kubeconfig"
