#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


# Checks for duplicates badge lines, assuming one badge per line as per std layout in headers across all my repos (more git / diff friendly)

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=lib/utils.sh
. "$srcdir/lib/utils.sh"

section "Checking README badges for duplicates and incorrect links"

ignored_lines_regex="
STATUS.md
nholuongut/github
nholuongut/centos-github
StarTrack
STARCHARTS.md
LinkedIn
Spotify
AWS Athena
MySQL
PostgreSQL
MariaDB
TeamCity
^=*$
https://aws.amazon.com
https://sonarcloud.io/dashboard
https://hub.docker.com/
https://img.shields.io/badge/
https://github.com/nholuongut/[[:alnum:]-]*$
"

start_time="$(start_timer)"

echo "checking for duplicates:"
echo

# uniq -d will cause silent pipe failure without dups otherwise
set +eo pipefail
# want splitting for args
# shellcheck disable=SC2046
duplicates="$(
    {
    # exact README lines
    # shellcheck disable=SC1117
    "$srcdir/../git/git_foreach_repo.sh" "grep -Eho '\[\!\[.*\]\(.*\)\]\(.*\)' README.md" |
    sort |
    uniq -d

    # any URLs
    #"$srcdir/../git/git_foreach_repo.sh" "grep -Eho '\[\!\[.*\]\(.*\)\]\(.*\)' README.md" |
    #grep -Eo '(http|https)://[a-zA-Z0-9./?=_%:#&,+-]*' |
    #sort |
    #uniq -d
    } |
    grep -vi $(IFS=$'\n'; for line in $ignored_lines_regex; do [[ "$line" =~ ^[[:space:]]*$ ]] && continue; printf "%s" " -e '$line'"; done)
)"
set -eo pipefail

github_dir="$(dirname "$srcdir")"

while read -r line; do
    if [ -z "${line// }" ]; then
        continue
    fi
    grep -F --color=yes "$line" "$github_dir"/*/README.md
    echo
done <<< "$duplicates"

if [ -n "$duplicates" ]; then
    exit 1
else
    echo "No duplicate badge lines found"
    echo
fi

time_taken "$start_time"
section2 "README badge checks passed"
echo
