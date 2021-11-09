#!/bin/bash
#set -e
set -x

export PROJECT=examples
export TF_IN_AUTOMATION=true
TERRAFORM_VERSION="latest"
echo "# build cli/terraform $TERRAFORM_VERSION"
make install-tf
./bin/terraform version

echo "# build docker cli/terraform $TERRAFORM_VERSION"
make build
make tf-version


cp examples/backend.tf.file.disable examples/backend.tf
echo "# validate terraform module"
make tf-validate PROJECT="examples"
