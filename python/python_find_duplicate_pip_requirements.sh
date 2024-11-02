#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


# Script to find duplicate Python Pip / PyPI module requirements across files

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=lib/utils.sh
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034
usage_args="[<pip_requirements_files>]"

for x in "$@"; do
    case "$x" in
    -h|--help)  usage
                ;;
    esac
done

found=0

if [ -n "$*" ]; then
    requirements_files="$*"
else
    requirements_files="$(find . -maxdepth 2 -name requirements.txt)"
    if [ -z "$requirements_files" ]; then
        usage "No requirements files found, please specify explicit path to requirements.txt"
    fi
fi

# need word splitting for different files
# shellcheck disable=SC2086
sed 's/#.*//;
     s/[<>=].*//;
     s/^[[:space:]]*//;
     s/[[:space:]]*$//;
     /^[[:space:]]*$/d;' $requirements_files |
sort |
uniq -d |
while read -r module ; do
    # need word splitting for different files
    # shellcheck disable=SC2086
    grep "^${module}[<>=]" $requirements_files
    ((found + 1))
done

if [ $found -gt 0 ]; then
    exit 1
fi
