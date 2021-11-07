#!/bin/bash
#
# start postinstall
# generate local.cfg
# generate config.cfg
#
echo "# RUNNING: $(dirname $0)/$(basename $0)"

set -e -o pipefail
libdir=/home/outscale
common_functions="$libdir/common_functions.sh"
[ -f "$common_functions" ] && source $common_functions

export no_proxy="$no_proxy,169.254.169.254"
wget_args="-q  -O -  -t 10 -T 10 -w 10"
meta_data_url="http://169.254.169.254/latest/meta-data/"

cat <<EOF > $libdir/local.cfg
# get meta data from http://169.254.169.254/latest/meta-data"
export META_DATA_LOCAL_IPV4="$( eval wget $wget_args $meta_data_url/local-ipv4)"
export META_DATA_PUBLIC_IPV4="$( eval wget $wget_args $meta_data_url/public-ipv4)"
export META_DATA_AVAILABILITY_ZONE="$(eval wget $wget_args $meta_data_url/placement/availability-zone)"
# get data volume id
export volume_id="$volume_id"
#
EOF

# place here all terraform/shell variables
cat <<'EOF' >$libdir/config.cfg
# configuration file for all shell scripts
%{ if ssh_authorized_keys != "" ~}
export ssh_authorized_keys='${ssh_authorized_keys}'
%{ endif ~}
%{ if docker_version != "" ~}
export docker_version="${docker_version}"
%{ endif ~}
%{ if docker_compose_version != "" ~}
export docker_compose_version="${docker_compose_version}"
%{ endif ~}
EOF
