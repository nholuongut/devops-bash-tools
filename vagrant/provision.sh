#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et

mkdir -pv /vagrant/logs

{

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x

bash_tools="/bash"

# shellcheck disable=SC1090,SC1091
source "$bash_tools/lib/utils.sh"

section "Running Vagrant Shell Provisioner Script - Base"

pushd /vagrant

mkdir -p /root/.ssh
sed 's/#.*//; /^[[:space:]]*$/d' /home/vagrant/.ssh/authorized_keys |
while read -r line; do
    if ! [ -f /root/.ssh/authorized_keys ] ||
       ! grep -Fqx "$line" /root/.ssh/authorized_keys; then
        echo "adding SSH authorized key to /root/.ssh/authorized_keys: $line"
        echo "$line" >> /root/.ssh/authorized_keys
    fi
done

pushd "$bash_tools"
echo >&2

timestamp "stripping 127.0.1.1 from /etc/hosts to avoid hostname resolve clash"
sed -ibak '/127.0.1.1/d' /etc/hosts

timestamp "adding /etc/hosts entries from Vagrantfile"
./vagrant/vagrant_hosts.sh /vagrant/Vagrantfile | ./bin/grep_or_append.sh /etc/hosts

timestamp "disabling swap"
./bin/disable_swap.sh
echo >&2

timestamp "custom shell configuration and config linking as user '$USER':"
make link
echo >&2
# above links as root, let's link as vagrant too
if [ $EUID = 0 ] && id vagrant &>/dev/null; then
    timestamp "custom shell configuration and config linking as user 'vagrant':'"
    su - vagrant -c "pushd '$bash_tools'; make link"
fi

packages="vim bash-completion"

timestamp "installing: $packages"
#apt-get update
#apt-get install -y vim bash-completion

# want splitting
# shellcheck disable=SC2086
./packages/install_packages_if_absent.sh $packages

} 2>&1 | tee -a /vagrant/logs/provision.log
