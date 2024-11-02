#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Install XCode CLI tools"
xcode-select --install || :  # ignore if already installed

run(){
    echo "Running $srcdir/$1"
    QUICK=1 "$srcdir/$1"
    echo
    echo
    echo "================================================================================"
}

echo
"$srcdir/shell_link.sh"

# homebrew script must be first
install_scripts="
install_homebrew.sh
install_ansible.sh
install_diff-so-fancy.sh
install_gcloud_sdk.sh
install_minikube.sh
install_minishift.sh
install_parquet-tools.sh
install_sdkman.sh
install_sdkman_all_sdks.sh
install_terraform.sh
install_travis.sh
"

for x in $install_scripts; do
    run "$x"
done
if [[ "$USER" =~ nholuongut|nho ]]; then
    run install_github_ssh_key.sh
fi
