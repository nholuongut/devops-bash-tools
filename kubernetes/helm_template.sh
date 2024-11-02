#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Templates a given Helm chart for local declaratively tracked and auto-repaired Kustomize deployments

Used to quickly update various GitOps configuration versions - see https://github.com/nholuongut/Kubernetes-configs


Requires helm to be installed

Tested on Helm 3.7.1
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="<repo-url> <repo/chart> [--version <version> -n <namespace> -f values.yaml ... <helm_options>]"

help_usage "$@"

min_args 2 "$@"

repo_url="$1"
chart="$2"
shift || :
shift || :

# doesn't really matter what this repo name is as long as it's consistent and can infer what it should be from the chart call
repo="${chart%%/*}"
release_name="${chart##*/}"  # for simplicity the release name can be the same as the chart, which is fine for most cases

if ! helm repo list | grep -q "^${repo}[[:space:]]"; then
    helm repo add "$repo" "$repo_url"
fi

helm template "$release_name" "$chart" "$@"
