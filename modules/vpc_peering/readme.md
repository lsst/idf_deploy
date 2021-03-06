# VPC Peering

This module allows creation of a VPC Network Peering between two networks.

The resources created/managed by this module are:

* one network peering from local network to peer network
* one network peering from peer network to local network

## Usage

Basic usage of this module is as follows:

```terraform
module "peering" {
  source = "terraform-google-modules/network/google//modules/network-peering"

  prefix        = "name-prefix"
  local_network = "<FIRST NETWORK SELF LINK>"
  peer_network  = "<SECOND NETWORK SELF LINK>"
}
```

If you need to create more than one peering for the same VPC Network (A -> B, A -> C) you have to use output from the first module as a dependency for the second one to keep order of peering creation (It is not currently possible to create more than one peering connection for a VPC Network at the same time).

```terraform
module "peering-a-b" {
  source = "terraform-google-modules/network/google//modules/network-peering"

  prefix        = "name-prefix"
  local_network = "<A NETWORK SELF LINK>"
  peer_network  = "<B NETWORK SELF LINK>"
}

module "peering-a-c" {
  source = "terraform-google-modules/network/google//modules/network-peering"

  prefix        = "name-prefix"
  local_network = "<A NETWORK SELF LINK>"
  peer_network  = "<C NETWORK SELF LINK>"

  module_depends_on = [module.peering-a-b.complete]
}
```

## Help Get Network Self Link

The module requires knowing the VPC Network Self Link for the `lcoal_network` as well as the `peer_network`. A Terraform `data` resource block can be used to help get this information. Go [here](../../runbook/vpc-peering.md) in the runbook for an example.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| export\_local\_custom\_routes | Export custom routes to peer network from local network. | `bool` | `false` | no |
| export\_peer\_custom\_routes | Export custom routes to local network from peer network. | `bool` | `false` | no |
| local\_network | Resource link of the network to add a peering to. | `string` | n/a | yes |
| module\_depends\_on | List of modules or resources this module depends on. | `list` | `[]` | no |
| peer\_network | Resource link of the peer network. | `string` | n/a | yes |
| prefix | Name prefix for the network peerings | `string` | `"network-peering"` | no |

## Outputs

| Name | Description |
|------|-------------|
| complete | Output to be used as a module dependency. |
| local\_network\_peering | Network peering resource. |
| peer\_network\_peering | Peer network peering resource. |