#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/git.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Finds GitHub Actions workflows without checkouts by scanning the .github/workflows/ yaml files

This is often an error and can be dangerous for security scanning tools as they then fail to scan the real code or generate any security alerts
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<directory>]"

help_usage "$@"

#min_args 1 "$@"

dir="${1:-}"

if is_blank "$dir"; then
    if is_in_git_repo; then
        git_root="$(git_root)"
        dir="$git_root/.github/workflows"
    else
        dir='.'
    fi
fi

if ! [[ "$dir" =~ /.github/workflows/?$ ]]; then
    dir+="/.github/workflows"
fi

if ! [ -d "$dir" ]; then
    die "ERROR: directory not found: $dir"
fi

filelist="$(find "$dir" -type f -name '*.y*ml' | sort)"

section 'GitHub Actions Workflows without checkout'

start_time="$(start_timer)"

count=0
files_without_checkout=""

while read -r filename; do
    if ! [ -f "$filename" ]; then
        die "ERROR: file not found: $filename"
    fi
    echo "checking $filename"
    if ! grep -Eq '^[^#]*(checkout|clone)' "$filename" &&
       ! grep -Eq '^[[:space:]]+uses:[[:space:]]*.+/.github/workflows/.+@.+' "$filename"; then
        echo
        echo "WARNING: no checkout detected in: $filename"
        echo
        files_without_checkout+="
$filename"
        ((count+=1))
    fi
done <<< "$filelist"

echo
if [ $count -gt 0 ]; then
    echo "ERROR: $count files without checkout detected:"
    die "$files_without_checkout"
fi

time_taken "$start_time"
section2 "OK: no AWS credentials found in Git"
echo
