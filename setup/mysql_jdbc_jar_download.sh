#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


# Useful to quickly get the MySQL connector jar eg. to upload to Kubernetes

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x

MYSQL_VERSION="${1:-8.0.22}"

curl -sSL --fail "https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-$MYSQL_VERSION.tar.gz" |
tar zxvf - -C . --strip 1 "mysql-connector-java-$MYSQL_VERSION/mysql-connector-java-$MYSQL_VERSION.jar"
