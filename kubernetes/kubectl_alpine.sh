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
Runs a quick Alpine pod on Kubernetes to debug things

Shares the same alpine pod for successive invocations of this script for speed

Arguments become options to 'kubectl run'
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<kubectl_options>]"

help_usage "$@"

image="alpine"

name="alpine-${USER:-$(whoami)}"

run_static_pod "$name" "$image" "$@"
