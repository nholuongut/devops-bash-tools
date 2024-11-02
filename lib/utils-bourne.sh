#!/bin/sh
#  vim:ts=4:sts=4:sw=4:et
#


set -eu
[ -n "${DEBUG:-}" ] && set -x
#srcdir_bash_tools_utils_bourne="$(cd "$(dirname "$0")" && pwd)"

if [ "${bash_tools_utils_bourne_imported:-0}" = 1 ]; then
    return 0
fi
bash_tools_utils_bourne_imported=1

am_root(){
    # shellcheck disable=SC2039,SC3028
    [ "${EUID:-${UID:-$(id -u)}}" -eq 0 ]
}

if am_root; then
    sudo=""
else
    sudo=sudo
fi
export sudo

export support_msg="Please raise a GitHub Issue at https://github.com/nholuongut/devops-bash-tools/issues"
