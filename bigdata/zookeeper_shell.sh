#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et

# Kafka's zookeeper-shell wrapper to auto-populate common options like the zookeeper addresses and znode parent

set -u
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# sources heap, kerberos, brokers, zookeepers etc
# shellcheck source=.bash.d/kafka.sh
. "$srcdir/.bash.d/kafka.sh"

# it's assigned in .bash.d/kafka.sh
# shellcheck disable=SC2154
exec zookeeper-shell.sh "${KAFKA_ZOOKEEPERS:-}${KAFKA_ZOOKEEPER_ROOT:-}" "$@"
