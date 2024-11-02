#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et

set -u
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# sources heap, kerberos, brokers, zookeepers etc
# shellcheck source=.bash.d/kafka.sh
. "$srcdir/.bash.d/kafka.sh"

# old version of kafka used --zookeeper, deprecated now
#kafka-topics.sh $kafka_zookeeper "$@"

# it's assigned in .bash.d/kafka.sh
# shellcheck disable=SC2154,SC2086
exec kafka-topics.sh $bootstrap_server "$@"
