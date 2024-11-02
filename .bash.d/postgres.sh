#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#

# ============================================================================ #
#                              P o s t g r e S Q L
# ============================================================================ #

bash_tools="${bash_tools:-$(dirname "${BASH_SOURCE[0]}")/..}"

# shellcheck disable=SC1090,SC1091
. "$bash_tools/.bash.d/os_detection.sh"

# shellcheck disable=SC1090,SC1091
. "$bash_tools/.bash.d/functions.sh"

# highest priority env var
alias pgpass='pass PGPASSWORD'
# mac
alias postgresd='postgres -D /usr/local/var/postgres'
