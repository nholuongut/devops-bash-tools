#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Kustomize builds and checks the resulting Kubernetes yaml for objects without namespaces specified, which can easily result in deployments to the wrong namespace

Useful to find common mistakes in YAMLs or Helm chart templates pulled through Kustomize that don't have namespaces unless you specify it explicitly in the kustomization.yaml

Uses the adjacent script kubernetes_check_objects_namespaces.sh

Requires yq version 4.18.1+
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<dir>]"

help_usage "$@"

dir="${1:-.}"

cd "$dir"

yaml="$(kustomize build --enable-helm)"

"$srcdir/kubernetes_check_objects_namespaced.sh" <<< "$yaml"
