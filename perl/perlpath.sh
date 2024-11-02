#!/usr/bin/env bash
# shellcheck disable=SC2230
#  vim:ts=4:sts=4:sw=4:et

# Prints the Perl @INC paths, one per line

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x

# copied from old bashrc function which is now ported under .bash.d/ too, but given here for convenience in case you are not running the full bash profile
perl -e 'print join("\n", @INC);'
