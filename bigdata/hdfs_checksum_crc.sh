#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x

usage(){
    cat <<EOF
Recurses HDFS path arguments outputting portable CRC32 checksums for each file
(can be used for HDFS vs local comparisons, whereas default MD5-of-MD5 cannot)

Calls HDFS command which is assumed to be in \$PATH

Capture stdout > file.txt for comparisons

Make sure to kinit before running this if using a production Kerberized cluster

This is slow because the HDFS command startup is slow and is called once per file path

Setting environment variable SKIP_ZERO_BYTE_FILES to any value will skip files with zero bytes to save time since
they always return the same checksum anyway.

Caveats:

This is slow because the HDFS command startup is slow and is called once per file path so doesn't scale well
If you want to skip zero byte files, set environment variable \$SKIP_ZERO_BYTE_FILES to any value

See Also:

hadoop_hdfs_files_native_checksums.jy

from the adjacent GitHub rep (outputs MD5-of-MD5 not CRC32 though):

https://github.com/nholuongut/python-for-devops

I would have written this version in Python but the Snakebite library doesn't support checksum extraction


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

hdfs dfs -ls -R "$@" |
grep -v '^d' |
skip_zero_byte_files |
awk '{ $1=$2=$3=$4=$5=$6=$7=""; print }' |
#sed 's/^[[:space:]]*//' |
while read -r filepath; do
    hdfs dfs -Ddfs.checksum.combine.mode=COMPOSITE_CRC -checksum "$filepath"
done
