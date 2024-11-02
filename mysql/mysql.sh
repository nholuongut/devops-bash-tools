#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Script to more easily connect to MySQL without having to repeatedly specify options like host, username and password

Leverages standard MySQL options as well as others likely to be found in the environment

https://dev.mysql.com/doc/refman/8.0/en/environment-variables.html

See also - GNU sql

Tested on MySQL 8.0.15
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<mysql_options>]"

#help_usage "$@"

#min_args 1 "$@"

for arg; do
    case "$arg" in
        --help) usage
                ;;
    esac
done

#opts=(${MYSQL_OPTS:-})
read -r -a opts MYSQL_OPTS

MYSQL_HOST="${MYSQL_HOST:-${HOST:-}}"
if [ -n "${MYSQL_HOST:-}" ]; then
    opts+=(-h "$MYSQL_HOST")
fi

MYSQL_PORT="${MYSQL_TCP_PORT:-${MYSQL_PORT:-${PORT:-}}}"
if [ -n "${MYSQL_PORT:-}" ]; then
    opts+=(-P "$MYSQL_PORT")
fi

MYSQL_USER="${MYSQL_USER:-${DBI_USER:-${USER:-}}}"
if [ -n "${MYSQL_USER:-}" ]; then
    opts+=(-u "$MYSQL_USER")
fi

MYSQL_PASSWORD="${MYSQL_PWD:-${MYSQL_PASSWORD:-${PASSWORD:-}}}"
if [ -n "${MYSQL_PASSWORD:-}" ]; then
    echo "WARNING: not auto-adding -p<password> for safety" >&2
    echo "exporting MYSQL_PWD instead but this is deprecated and may not work in future versions" >&2
    #opts+=(-p"$MYSQL_PASSWORD")
    export MYSQL_PWD="$MYSQL_PASSWORD"
fi

MYSQL_DATABASE="${MYSQL_DATABASE:-${DATABASE:-}}"
if [ -n "${MYSQL_DATABASE:-}" ]; then
    opts+=(-d "$MYSQL_DATABASE")
fi

# split opts
# shellcheck disable=SC2086
exec mysql "${opts[@]}" "$@"
