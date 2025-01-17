#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#  args: vagrant/kubernetes/Vagrantfile
#

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Calculates the total combined RAM in MB allocated to all VMs in one or more Vagrantfiles

Accepts one or more Vagrantfiles as arguments, otherwise tries to read \$PWD/Vagrantfile or /vagrant/Vagrantfile for convenience

Tested on vagrant/kubernetes/Vagrantfile in this repo
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="<Vagrantfile>"

help_usage "$@"

if [ $# -gt 0 ]; then
    Vagrantfiles=("$@")
elif [ -f Vagrantfile ]; then
    Vagrantfiles=(Vagrantfile)
elif [ -f /vagrant/Vagrantfile ]; then
    # auto-detect when running inside a Vagrant VM
    Vagrantfiles=(/vagrant/Vagrantfile)
else
    usage "Vagrantfile not specified and no Vagrantfile found in \$PWD or /vagrant/"
fi

grep -E '^[^#]+\.memory' "${Vagrantfiles[@]}" |
sed 's/.*=[[:space:]]*//' |
grep -E '^[[:digit:]]+(\.[[:digit:]]+)?$' |
tr '\n' '+' |
sed 's/+$//' |
bc -l
