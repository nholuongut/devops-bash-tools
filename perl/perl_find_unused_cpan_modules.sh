#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


# Script to find unused Perl CPAN module requirements in the current directory tree

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=lib/utils.sh
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034
usage_args="[<setup/cpan_requirements.txt>]"

for x in "$@"; do
    case "$x" in
    -h|--help)  usage
                ;;
    esac
done

if [ $# -gt 0 ]; then
    requirements_files="$*"
else
    # might be more confusing in perl tools to find unused modules in subdirs like perl lib, so just stick to local
    #requirements_files="$(find . -name cpan-requirements.txt)"
    requirements_files="$(find . -maxdepth 2 -name cpan-requirements.txt)"
    if [ -z "$requirements_files" ]; then
        usage "No requirements files found, please specify explicit path to cpan-requirements.txt"
    fi
fi

found=0

# want splitting of requirements files to separate files
# shellcheck disable=SC2086
cpan_modules="$(
    sed 's/#.*//;
         s/@.*//;
         s/^[[:space:]]*//;
         s/[[:space:]]*$//;
         /^[[:space:]]*$/d;' $requirements_files |
    sort -u
)"

while read -r module; do
        # grep -R is sloooow by comparison to git grep
    if ! \
        git grep "^[[:space:]]*\\(use\\|require\\|import\\)[[:space:]]\\+$module" |
        grep -v 'cpan-requirements.*.txt' |
        grep -q .; then
            echo "$module"
            ((found + 1))
    fi
done <<< "$cpan_modules"

if [ $found -gt 0 ]; then
    exit 1
fi
