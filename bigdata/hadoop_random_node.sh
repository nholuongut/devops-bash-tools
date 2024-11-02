#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
# Script to print a random Hadoop node by parsing the Hadoop topology map from /etc
#
# Tested on CDH 5.10
#
# See also:
#
#   find_active_*.py - https://github.com/nholuongut/python-for-devops
#
#   HAProxy Configs for many Hadoop and other technologies - https://github.com/nholuongutnho/HAProxy-configs
#

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x

topology_map="${HADOOP_TOPOLOGY_MAP:-/etc/hadoop/conf/topology.map}"

if ! [ -f "$topology_map" ]; then
    echo "File not found: $topology_map. Did you run this on a Hadoop node?" >&2
    exit 1
fi

# returns datanodes in the topology map by omitting nodes with that are masters / namenodes / control nodes
awk -F'"' '/<node name="[A-Za-z]/{print $2}' "$topology_map" |
grep -Ev '^[^.]*(name|master|control)' |
shuf -n 1
