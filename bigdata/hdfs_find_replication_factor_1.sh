#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x

usage(){
    cat <<EOF
Recurses HDFS path arguments outputting any HDFS files with replication factor 1

These files cause alerts during single node downtime / maintenance due to missing blocks and
should really be set to replication factor 3

Calls HDFS command which is assumed to be in \$PATH

Make sure to kinit before running this if using a production Kerberized cluster

Setting environment variable SKIP_ZERO_BYTE_FILES to any value will not list files with zero bytes
Setting environment variable SET_REPLICATION_FACTOR_3 to any value will set any files found with
replication factor 1 back to replication factor 3


See also:

hdfs_find_replication_factor_1.py in DevOps Python tools repo which can
also reset these found files back to replication factor 3 to fix the issue

https://github.com/nholuongut/python-for-devops


usage: ${0##*/} <file_or_directory_paths>


EOF
    exit 3
}

if [[ "${1:-}" =~ ^- ]]; then
    usage
fi

skip_zero_byte_files(){
    if [ -n "${SKIP_ZERO_BYTE_FILES:-}" ]; then
        awk '{if($5 != 0) print }'
    else
        cat
    fi
}

set_replication_factor_3(){
    if [ -n "${SET_REPLICATION_FACTOR_3:-}" ]; then
        xargs --no-run-if-empty hdfs dfs -setrep 3
    else
        cat
    fi
}

hdfs dfs -ls -R "$@" |
grep -v '^d' |
skip_zero_byte_files |
awk '{ if ($2 == 1) { $1=$2=$3=$4=$5=$6=$7=""; print } }' |
sed 's/^[[:space:]]*//' |
set_replication_factor_3
