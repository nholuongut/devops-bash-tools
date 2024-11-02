#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Runs a quick SQLite with the Chinook sample database

Downloads the Chinook database if not present, then drops in to SQLite with it loaded for fast testing
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args=""

help_usage "$@"

db=chinook.sqlite

cd "$srcdir"

if ! [ -f "$db" ]; then
    wget -O "$db" 'https://github.com/lerocha/chinook-database/blob/master/ChinookDatabase/DataSources/Chinook_Sqlite.sqlite?raw=true'
fi

sqlite3 "$db"
