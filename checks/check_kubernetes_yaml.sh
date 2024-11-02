#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Checks one or more Kubernetes yaml files for linting and schema issues
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="file1.yaml [file2.yaml file3.yaml ...]"

help_usage "$@"

min_args 1 "$@"

for filename in "$@"; do
    # dereference symlinks, lib/utils.sh uses greadlink if on mac
    filename="$(readlink -m "$filename")"

    "$srcdir/check_yaml.sh" "$filename"

    if type -P datree &>/dev/null; then
        # only relevant if named exactly kustomization.yaml
        if [[ "$filename" =~ ^(.*/)kustomization.ya?ml$ ]]; then
            section "Datree Kubernetes Kustomize Check"
            datree kustomize test "$(dirname "$filename")"
        else
            section "Datree Kubernetes Check"
            datree test --only-k8s-files --ignore-missing-schemas "$filename"
        fi
        echo
        section2 "Datree Kubernetes Check Passed"
    fi
done
