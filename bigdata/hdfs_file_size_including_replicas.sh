#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x

usage(){
    cat <<EOF
Recurses HDFS path arguments outputting:

<disk_space_for_all_replicas>     <filename>

Calls HDFS command which is assumed to be in \$PATH

Make sure to kinit before running this if using a production Kerberized cluster


usage: ${0##*/} <file_or_directory_paths> [hdfs_dfs_du_options]


EOF
    exit 3
}

for arg; do
    case "$arg" in
        # not including -h here because du -h is needed for human readable format
        --help) usage
                ;;
    esac
done

# if using -h there will be more columns so remove cols 1 + 2 and use cols 3 + 4 for sizes including replicas eg.
#
# 21.7 M  65.0 M  hdfs://nameservice1/user/hive/warehouse/...
#
# otherwise will be in format
#
# 22713480  68140440  hdfs://nameservice1/user/hive/warehouse/...

hdfs dfs -du "$@" |
awk '{ if($2 ~ /[A-Za-z]/){ $1=""; $2="" } else { $2=""  }; print  }' |
column -t
