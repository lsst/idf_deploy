# GCP VPC Peering

Google Cloud [VPC Network Peering](https://cloud.google.com/vpc/docs/vpc-peering) allows internal IP address connectivity across two Virtual Private Cloud (VPC) networks regardless of whether they belong to the same project or the same organization.

VPC Network Peering enables you to connect VPC networks so that workloads in different VPC networks can communicate internally. Traffic stays within Google's network and doesn't traverse the public internet.

## New VPC Peer

A VPC Peer must be configured and established on both sides. The [VPC Peering module](../modules/vpc_peering) requires the network self link for the `local peer` as well as the `remote peer`. To get the respected `network_self_link` from both sides of the VPC, we can use different `data` resource blocks to find our desired project which in turn helps find the desired `network_self_link` in the VPC.

## Usage

This example uses the `data` resource blocks to find the `local peer` project using the filter API to sift projects based on the labels assigned to the project and another `data` resource block to get the network self link from the project.

```terraform
data "google_projects" "local_peer_project" {
  filter = "labels.application_name=qserv labels.environment=dev"
}

data "google_compute_network" "local_network" {
  project = data.google_projects.local_peer_project.projects[0].project_id
  name    = "qserv-dev-vpc"
```

You may use the same example block to get the `network_self_link` for the `remote peer` by changing the appropriate labels for the filter and providing the correct network name.

## GitHub Actions

A new pipeline needs to be created and deployed using the existing [vpc peering pipeline](../.github/workflows/qserv-dev-vpcpeer-tf.yaml) as an example. Be sure to change the appropriate directory names and `tfvars` file names in the pipeline.