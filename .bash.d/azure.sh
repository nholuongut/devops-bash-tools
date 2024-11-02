#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#  shellcheck disable=SC1090,SC1091
#

# ============================================================================ #
#                                   A z u r e
# ============================================================================ #

srcdir="${srcdir:-$(dirname "${BASH_SOURCE[0]}")/..}"

# shellcheck disable=SC1090,SC1091
#type add_PATH &>/dev/null || . "$srcdir/.bash.d/paths.sh"

# Azure CLI from script install, installs to $HOME/lib and $HOME/bin
if [ -f ~/lib/azure-cli/az.completion ]; then
    source ~/lib/azure-cli/az.completion
fi

# assh is an alias to awless ssh
azssh(){
    local ip
    ip="$(az vm show --name "$1" -d --query "[publicIps]" -o tsv)"
    ssh azureuser@"$ip"
}
