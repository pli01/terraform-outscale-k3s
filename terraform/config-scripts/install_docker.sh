#!/bin/bash
echo "# RUNNING: $(dirname $0)/$(basename $0)"
set -e -o pipefail
cloud_user=outscale
libdir=/home/$cloud_user

[ -f ${libdir}/local.cfg ] && source ${libdir}/local.cfg
[ -f ${libdir}/config.cfg ] && source ${libdir}/config.cfg

export docker_version="${docker_version:-docker-ce}"
export docker_compose_version="${docker_compose_version:-1.21.2}"

# Package
PACKAGE_CUSTOM="sudo curl jq apt-transport-https ca-certificates curl software-properties-common gnupg2 make git unzip python-pip"
apt-get -q update && apt-get install -qy --no-install-recommends $PACKAGE_CUSTOM

# Docker
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
apt-get update
apt-get install -qy $docker_version
usermod -aG docker $cloud_user

systemctl daemon-reload
systemctl restart docker

pip install "docker-compose==$docker_compose_version"

docker version || exit $?
docker-compose  version || exit $?
id $cloud_user  | grep '(docker)' || exit $?
