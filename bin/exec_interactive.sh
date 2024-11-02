#!/bin/sh
#  vim:ts=4:sts=4:sw=4:et

# cannot -set -o pipefail because some docker images version of 'sh' do not support it, namely debian and ubuntu
set -eu
[ -n "${DEBUG:-}" ] && set -x

# cannot allow set -e because it will cause an exit before the exec to interactive
(
exec "${SHELL:-sh}" -i 3<<EOF 4<&0 <&3
  set +e
    $@
  exec 3>&- <&4
EOF
)
