#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


# Useful to quickly download the PostgreSQL JDBC jar

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x

POSTGRESQL_JDBC_VERSION="${1:-42.2.18}"

if type -P wget; then
    wget -O "postgresql-$POSTGRESQL_JDBC_VERSION.jar" "https://jdbc.postgresql.org/download/postgresql-$POSTGRESQL_JDBC_VERSION.jar"
else
    curl --fail "https://jdbc.postgresql.org/download/postgresql-$POSTGRESQL_JDBC_VERSION.jar" > "postgresql-$POSTGRESQL_JDBC_VERSION.jar"
fi
