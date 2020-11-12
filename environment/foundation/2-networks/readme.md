# 2-networks

The purpose of this step is to setup shared VPCs with default DNS, NAT, and baseline firewall rules.

## Prerequirements

1. 0-bootstrap (seed project) executed successfully
1. 1-org executed successfully

## Usage

1. Change into 2-networks directory
1. Copy tfvars by running `cp terraform.tfvars.example terraform.tfvars` and update `terraform.tfvars` with values from your environment.
1. Push the changes back into the repo using `git add .` next `git commit -m "updated tfvars"`, then `git push origin [branch_name]`
    1. If your .gitignore is blocking `*.tfvars` then you'll need to force the update using `git add . -f`
1. This push will kickoff the CloudBuild trigger for `2-networks` and start deploying

## Expected Outcome

The expected outcome from this default build is a Shared VPC in a host project that deploys a couple of default firewall rules for Identity And Access Management. A Cloud NAT that is attached to the location for internet access. Cloud DNS is deployed using a [hybrid architecture](https://cloud.google.com/dns/docs/best-practices-dns#hybrid_architecture_using_a_single_shared_vpc_network)


## Providers

| Name | Version |
|------|---------|
| google | ~> 3.1 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| billing\_account | Billing account to attach to projects. | `any` | n/a | yes |
| default\_region | Default subnet region standard\_shared\_vpc currently only configures one region | `string` | `"us-central1"` | no |
| domain | Domain | `any` | n/a | yes |
| network\_name | Name of the VPC | `string` | `"shared-vpc-prod"` | no |
| org\_id | Organization ID | `any` | n/a | yes |
| subnets\_1 | Subnetwork information | `list` | <pre>[<br>  {<br>    "description": "Prod subnet.",<br>    "subnet_flow_logs": "true",<br>    "subnet_flow_logs_interval": "INTERVAL_15_MIN",<br>    "subnet_flow_logs_metadata": "INCLUDE_ALL_METADATA",<br>    "subnet_flow_logs_sampling": 0.3,<br>    "subnet_ip": "172.30.0.0/20",<br>    "subnet_name": "us-central1-prod-1",<br>    "subnet_private_access": "true",<br>    "subnet_region": "us-central1"<br>  }<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| prod\_host\_project\_id | The host project ID for prod |
| prod\_network\_name | The name of the VPC being created |
| prod\_network\_self\_link | The URI of the VPC being created |
| prod\_subnets\_ips | The IPs and CIDRs of the subnets being created |
| prod\_subnets\_names | The names of the subnets being created |
| prod\_subnets\_secondary\_ranges | The secondary ranges associated with these subnets |
| prod\_subnets\_self\_links | The self-links of subnets being created |