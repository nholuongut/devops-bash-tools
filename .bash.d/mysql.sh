#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#

# ============================================================================ #
#                                   M y S Q L
# ============================================================================ #

bash_tools="${bash_tools:-$(dirname "${BASH_SOURCE[0]}")/..}"

# shellcheck disable=SC1090,SC1091
. "$bash_tools/.bash.d/os_detection.sh"

# shellcheck disable=SC1090,SC1091
type pass &>/dev/null ||
. "$bash_tools/.bash.d/functions.sh"

# highest priority env var first, common one second - export as both
alias mysqlpass='pass MYSQL_PWD MYSQL_PASSWORD'
