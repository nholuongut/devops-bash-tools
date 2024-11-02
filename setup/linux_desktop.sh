#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#


set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

run(){
    echo "Running $srcdir/$1"
    QUICK=1 "$srcdir/$1"
    echo
    echo
    echo "================================================================================"
}

install_scripts="
install_ansible.sh
install_diff-so-fancy.sh
install_gcloud_sdk.sh
install_parquet-tools.sh
install_sdkman.sh
install_sdkman_all_sdks.sh
install_terraform.sh
install_travis.sh
install_vundle.sh
"

for x in $install_scripts; do
    run "$x"
done
if [[ "$USER" =~ nholuongut|nho ]]; then
    run install_github_ssh_key.sh
fi
echo
"$srcdir/shell_link.sh"
