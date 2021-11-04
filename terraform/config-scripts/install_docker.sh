#!/bin/bash
set -ex
# Package
PACKAGE_CUSTOM="sudo curl jq apt-transport-https ca-certificates curl software-properties-common gnupg2 make git unzip python-pip"
apt-get -q update && apt-get install -qy --no-install-recommends $PACKAGE_CUSTOM

# Docker
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
apt-get update
apt-get install -qy docker-ce
usermod -aG docker outscale

systemctl daemon-reload
systemctl restart docker

export docker_compose_version="${docker_compose_version:-1.21.2}"
pip install "docker-compose==$docker_compose_version"

docker version || exit $?
docker-compose  version || exit $?
id outscale  | grep '(docker)' || exit $?
