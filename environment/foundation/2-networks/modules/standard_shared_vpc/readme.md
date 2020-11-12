# Shared VPC Terraform Module

This GCP Shared VPC Terraform module deploys a Shared VPC in a host project.


### DNS Best Practice

https://cloud.google.com/dns/docs/best-practices-dns#hybrid_architecture_using_a_single_shared_vpc_network

## Providers

| Name | Version |
|------|---------|
| google | n/a |
| google-beta | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| authoritative\_domain | Zone domain, must end with a period. | `string` | `"gcp.example.com."` | no |
| authoritative\_name | Zone name, must be unique within the project. | `string` | `"gcp-example-com"` | no |
| bgp\_asn | BGP ASN for default cloud router. | `string` | `64513` | no |
| default\_fw\_rules\_enabled | Toggle creation of default firewall rules. | `bool` | `true` | no |
| default\_region | Default subnet region standard\_shared\_vpc currently only configures one region. | `string` | n/a | yes |
| dns\_enable\_inbound\_forwarding | Toggle inbound query forwarding for VPC DNS. | `bool` | `true` | no |
| dns\_enable\_logging | Toggle DNS logging for VPC DNS. | `bool` | `true` | no |
| fwd\_domain | Zone domain, must end with a period. | `string` | `"corp.example."` | no |
| fwd\_name | Zone name, must be unique within the project. | `string` | `"corp-example-com"` | no |
| nat\_num\_addresses | Number of external IPs to reserve for Cloud NAT. | `number` | `2` | no |
| network\_name | Name for VPC. | `string` | n/a | yes |
| project\_id | Project ID for Shared VPC. | `string` | n/a | yes |
| secondary\_ranges | Secondary ranges that will be used in some of the subnets | `map(list(object({ range_name = string, ip_cidr_range = string })))` | `{}` | no |
| subnets | The list of subnets being created | `list(map(string))` | `[]` | no |
| target\_name\_server\_addresses | List of target name servers for forwarding zone. | `list(string)` | <pre>[<br>  "8.8.8.8",<br>  "8.8.4.4"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| network\_name | The name of the VPC being created |
| network\_self\_link | The URI of the VPC being created |
| subnets\_flow\_logs | Whether the subnets have VPC flow logs enabled |
| subnets\_ips | The IPs and CIDRs of the subnets being created |
| subnets\_names | The names of the subnets being created |
| subnets\_private\_access | Whether the subnets have access to Google API's without a public IP |
| subnets\_regions | The region where the subnets will be created |
| subnets\_secondary\_ranges | The secondary ranges associated with these subnets |
| subnets\_self\_links | The self-links of subnets being created |