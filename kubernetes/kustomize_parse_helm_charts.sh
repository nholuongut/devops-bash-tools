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
Parses the Helm Charts from one or more Kustomize kustomization.yaml files into a TSV format for post-processing such as installing

Useful to install the Helm charts the old fashioned non-GitOps way via Helm CLI so that tools like Nova can be run on the live helm releases to detect old outdated charts

All arguments are passed straight to yq and must be kustomization.yaml files or valid --options


Output Format:

<repo_url>    <chart_name>     <chart_version>    <values_file>


Any field not found or commented out like valuesFile in kustomization.yaml will return 'null' for that field


Used by adjacent script kustomize_install_helm_charts.sh in CI/CD GitHub Actions for repo:

    https://github.com/nholuongut/Kubernetes-configs


Requires yq and installs it if not found
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="kustomization.yaml kustommization2.yaml..."

help_usage "$@"

min_args 1 "$@"

type -P yq &>/dev/null || "$srcdir/../setup/install_yq.sh"

yq '.helmCharts[] | [.repo, .name, .version, .valuesFile] | @tsv' "$@" --no-doc --no-colors |
sed '/^[[:space:]]*$/d' |
sort -u |
column -t
