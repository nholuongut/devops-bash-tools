#!/bin/sh
#  vim:ts=4:sts=4:sw=4:et
#

# Prints concise git log for $PWD repo - used by all repos headers to signify their release in CI logs

set -eu #o pipefail
[ -n "${DEBUG:-}" ] && set -x

# setting TERM and --no-pager are attempted workarounds to breakage in CircleCI, hangs with 'WARNING: terminal is not fully functional' (press RETURN)
export TERM=xterm
git --no-pager log -n 1 --pretty=format:'>>> %H  %ai  (%an)  %s%n'
