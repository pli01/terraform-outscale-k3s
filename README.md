# terraform-outscale-k3s

[![CI](https://github.com/pli01/terraform-outscale-k3s/actions/workflows/main.yml/badge.svg)](https://github.com/pli01/terraform-outscale-k3s/actions/workflows/main.yml)

Terraform modules which creates a k3s cluster with portainer webadmin and multiple customized functional resources on an Openstack Project/Tenant

Project used:
* [k3s](https://k3s.io/)
* [portainer](https://www.portainer.io/)

Workload users are accessible through a dedicated URL from the `lb` instance and Floating ip

Administration of the kubernetes cluster is accessible through a decicated URL from the `lb_admin` instance and Floating ip, allowing:
* access to the kubernetes API
* administration by a web interface based on portainer.io

`k3s.io` allows you to easily deploy a fully kubernetes cluster in 2 steps
`portainer.io` allows you to have manage kubernetes cluster, users workload, authentification , console / web access to the cluster as well as to the pod / container!


![K3S cluster archi](doc/terraform-outscale-k3s-archi.png)

This module create the following resources
  * 1 network/subnet
  * floating ips
  * security group/rule for bastion/http_proxy/loadbalancer/logs/k3s
  * 1 bastion instance (for ssh acces)
  * 1 http_proxy instance (corporate proxy)
  * 1 log instance (override with your own url log_install_script)
  * N user load-balancer
  * N admin load-balancer
  * 1 k3s master instance (override with your own url k3_master_install_script)
  * N k3s agent instances (override with your own url k3s_agent_install_script)
  * Terraform backend state stored in s3

K3 cluster will contain the portainer dashboard for easy admin


![Full archi](doc/terraform-outscale-k3s.png)

# Notes:

Prereq:
  * outscale credentials / tenant
  * aws credentials / tenant
  * (optional) dockerhub credentials
  * (optional) corporate http proxy credentials

this terraform module
  * provision outscale resources (network,volume,floating-ip security group)
  * provision instances and cloud_config template
  * customize cloud-init install script with install_script variables

Custom install script used:
  * [k3s cluster install](./samples/app/k3s/)
  * TODO: [EFK log docker stack (Elastic,Kibana,Fluentd,Curator)](https://github.com/pli01/log-stack/)
  * TODO: [beat docker stack (metricbeat,heartbeat)](https://github.com/pli01/beat-stack/)

### Terraform variables
See details in `terraform/variables.tf` file and `examples` dir

Common variables
| Name | description | Value |
| --- | --- | --- |
| `prefix_name` | environment prefix | `test` |
| `image` | cloud image | `debian9-latest` |
| `vol_size` | root volume size (Go) | `10` |
| `vol_type` | volume type | `ceph` |
| `key_name` | key_name to allow ssh connection  | `debian` |
| `bastion_count` | bastion count (0 = disable, 1=enable) | `1` |
| `bastion_flavor` | bastion flavor | `standard-2.2` |
| `bastion_data_enable` | data added disk (true or false)| `false` |
| `bastion_data_size` | data disk size (Go)| `0` |
| `dockerhub_login` | dockerhub_login | `login` |
| `dockerhub_token` | dockerhub_token | `token` |
| `github_token` | github_token | `github_token` |
| `docker_registry_username` | docker_registry_username | `docker_registry_username` |
| `docker_registry_token` | docker_registry_token | `docker_registry_token` |
| `syslog_relay` | syslog_relay  | `floating ip log stack` |
||||
| `k3s_master_count` | k3s master instance count (0 = disable, 1,2,3...N) | `1` |
| `k3s_master_flavor` | app flavor | `standard-2.2` |
| `k3s_master_install_script` | k3s master install script url to deploy | `https://raw.githubusercontent.com/pli01/terraform-outscale-k3s/main/samples/app/k3s/k3s-master-install.sh` |
| `k3s_master_variables` | k3s_master_variables map ({ VAR=value, VAR2=value2}) | `{K3S_TOKEN = "_MY_SUPER_K3S_TOKEN_"}` |
||||
| `k3s_agent_count` | k3s agent instance count (0 = disable, 1,2,3...N) | `1` |
| `k3s_agent_flavor` | k3s agent flavor | `standard-2.2` |
| `k3s_agent_install_script` | k3s agent install script url to deploy | `https://raw.githubusercontent.com/pli01/terraform-outscale-k3s/main/samples/app/k3s/k3s-agent-install.sh` |
| `k3s_agent_variables` | k3s_agent_variables map ({ VAR=value, VAR2=value2}) | `{K3S_TOKEN = "_MY_SUPER_K3S_TOKEN_"}` |

### Variables
You can override terraform variables
```
Variable Outscale API credentials
  OUTSCALE_REGION=eu-west-1
  OUTSCALE_ACCESSKEYID=XXXXX
  OUTSCALE_SECRETKEYID=YYYYYY

Variable AWS API credentials (for S3 backend)
  AWS_ACCESS_KEY_ID: $AWS_ACCESS_KEY_ID
  AWS_SECRET_ACCESS_KEY: $AWS_SECRET_ACCESS_KEY
  AWS_DEFAULT_REGION: $AWS_DEFAULT_REGION
  AWS_ROLE_ARN: $AWS_ROLE_ARN
  AWS_S3_ENDPOINT: $AWS_S3_ENDPOINT
  AWS_IAM_ENDPOINT: $AWS_IAM_ENDPOINT

Variable TF_VAR_xxxx
TF_VAR_tinyproxy_proxy_authorization = base64(login:password)

```

## Local build terraform

You can also test,validate,plan,apply terraform file from the local docker image before commit your work

* Build docker image with terraform/terragrunt
```
make build
```
* Test, plan, deploy
```
# format tf file
make tf-format PROJECT="terraform"
#
make tf-validate PROJECT="terraform"
make tf-plan PROJECT="terraform" TF_VAR_FILE="-var-file=/data/terraform/env/dev/config.auto.vars"
make tf-apply PROJECT="terraform" TF_VAR_FILE="-var-file=/data/terraform/env/dev/config.auto.vars"
# taint and redeploy
make tf-taint tf-apply PROJECT="terraform" TF_VAR_FILE="-var-file=/data/terraform/env/dev/config.auto.vars" TAINT_ADDRESS="module.k3s-cluster.module.bastion.outscale_vm.bastion[0]"
# destroy
make tf-deploy PROJECT="terraform" TF_VAR_FILE="-var-file=/data/terraform/env/dev/config.auto.vars"
```

## deploy your own ressources
* You can define your deployment in an dedicated directory (see examples directory)
* choose your backend (file or s3)
```
* If S3 backend is used
# configure s3 api outscale credentials
export AWS_ACCESS_KEY_ID=XX
export AWS_SECRET_ACCESS_KEY=YY
export AWS_DEFAULT_REGION=cloudgouv-eu-west-1
export AWS_ROLE_ARN=arn:aws:iam::ZZZ
export AWS_IAM_ENDPOINT=eim.cloudgouv-eu-west-1.outscale.com
export AWS_S3_ENDPOINT=oos.cloudgouv-eu-west-1.outscale.com
export AWS_DEFAULT_OUTPUT=table

# create S3 bucket
aws s3api create-bucket --bucket test-k3s-terraform-state --acl private
aws s3api put-bucket-versioning --bucket test-k3s-terraform-state --versioning-configuration "Status=Enabled"
```
* deploy your k3s cluster
```
# configure outscale api credentials
export OUTSCALE_REGION="cloudgouv-eu-west-1"
export OUTSCALE_ACCESSKEYID="XXX"
export OUTSCALE_SECRETKEYID="YYY"

# deploy k3s cluster step by step
# bastion_count=1
# k3s_master_count=0
# k3s_agent_count=0
make tf-apply PROJECT="examples" TF_VAR_FILE='-var-file=/data/${PROJECT}/env/test/config.auto.vars'
# deploy k3s  master
# k3s_master_count=1
# k3s_agent_count=0
make tf-apply PROJECT="examples" TF_VAR_FILE='-var-file=/data/${PROJECT}/env/test/config.auto.vars'
# deploy k3s  agent
# k3s_agent_count=1
make tf-apply PROJECT="examples" TF_VAR_FILE='-var-file=/data/${PROJECT}/env/test/config.auto.vars'
```

* To remove agent node

```
# in kubectl console
kubectl drain node XXX
kubectl delete node XXX

# remove k3_agent or redeploy
```
