#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et


# Tries to installs Python snakebite module for Python 3 or Python 2 downgrading each time to try another version

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

"$srcdir/../python/python_pip_install.sh" "snakebite-py3[kerberos]" ||
"$srcdir/../python/python_pip_install.sh" "snakebite-py3" ||
"$srcdir/../python/python_pip_install.sh" "snakebite[kerberos]" ||
"$srcdir/../python/python_pip_install.sh" "snakebite"
