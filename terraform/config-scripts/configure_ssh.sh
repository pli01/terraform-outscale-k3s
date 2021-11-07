#!/bin/bash
echo "# RUNNING: $(dirname $0)/$(basename $0)"
set -x
set -e -o pipefail
cloud_user=outscale
libdir=/home/$cloud_user

[ -f ${libdir}/local.cfg ] && source ${libdir}/local.cfg
[ -f ${libdir}/config.cfg ] && source ${libdir}/config.cfg

# Install minimal package
PACKAGE_CUSTOM="jq"
apt-get -q update
apt-get install -qy --no-install-recommends $PACKAGE_CUSTOM

# Add authorized_keys
if [ -n "$ssh_authorized_keys" ] ; then
echo "## add authorized_keys"
HOME=/home/$cloud_user
if [ ! -d $HOME/.ssh ] ; then mkdir -p $HOME/.ssh ; fi
echo "$ssh_authorized_keys" |  jq -r ".[]" >> $HOME/.ssh/authorized_keys
chown $cloud_user. -R $HOME/.ssh
HOME=/root
fi

# enable ssh forwarding
echo "## AllowTcpForwarding yes"
sed -i.orig -e 's/^AllowTcpForwarding.*//g; $a\AllowTcpForwarding yes' /etc/ssh/sshd_config
grep "^AllowTcpForwarding yes" /etc/ssh/sshd_config || exit 1

echo "## AllowAgentForwarding yes"
sed -i.orig -e 's/^AllowAgentForwarding.*//g; $a\AllowAgentForwarding yes' /etc/ssh/sshd_config
grep "^AllowAgentForwarding yes" /etc/ssh/sshd_config || exit 1

# restart ssh
service ssh restart
