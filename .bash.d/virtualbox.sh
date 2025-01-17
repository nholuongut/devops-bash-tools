#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#
# ============================================================================ #
#                              V i r t u a l B o x
# ============================================================================ #

vboxmanage_list_vms="VBoxManage list runningvms"
# shellcheck disable=SC2139
alias vbox_running="echo $vboxmanage_list_vms; $vboxmanage_list_vms"
alias vr=vbox_running
unset vboxmanage_list_vms

alias startvm="VBoxManage startvm"
alias stopvm="VBoxManage controlvm acpipowerbutton"
alias poweroff="VBoxManage controlvm poweroff"
alias savestate="VBoxManage savestate"
alias controlvm="VBoxManage controlvm"

#docker(){
#    local vm='boot2docker-vm'
#    VBoxManage list runningvms | grep -q "$vm" || VBoxManage startvm "$vm"
#    command docker "$@"
#}

# fixvbox() in .bash.d/apple.sh restarts VirtualBox on Mac OSX only

fixvboxnet(){
    sudo ifconfig vboxnet0 down
    sudo ifconfig vboxnet0 up
}
