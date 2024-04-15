# Terraform GCP Foundation and Deployment

This code repo is intended to deploy a solid Google Cloud Platform foundation based off of [Google's Cloud security foundation guide](https://services.google.com/fh/files/misc/google-cloud-security-foundations-guide.pdf). This guide provides our opinionated security foundations blueprint and captures a step-by-step view of how to configure and deploy your Google Cloud estate. This document can provide a good reference and starting point because we highlight key topics to consider. In each topic, we provide background and discussion of why we made each of our choices.

If what is desired is a new environment parallel to the existing ones at the IDF, please consult [the New Environment documentation](./NEW_ENVIRONMENT.md).

## Repo Structure

### [.github workflows](./.github/workflows)
The [.github workflows](./.github/workflows) directory contains the build steps used when a pipeline is initiated. All of the pipelines are located in this directory.

### [deployments under environment](./environment/deployments)
The [deployments](./environment/deployments) directory is used as the main directory to place new applications. Each new application will have its own dedicated directory with a subdirectory with the different `*.tfvars` files for differences between different environments like `dev`,`int`, and `stable`. These `*.tfvars` files help differentiate between projects and supply the inputs for the different modules.

### [modules](./modules)
The [modules](./modules) directory is where the blueprints of the infrastructure are stored.

### [runbook](./runbook)
The runbook directory is used for documentation.



## Where to Begin

To start, you will need to go into the [foundation](./environment/foundation) directory. This directoy is the building block to deploying a solid and secure GCP foundation. The foundation directory has it's own [readme](./environment/foundation/readme.md) with steps.

## Where to Continue

After all the steps have been completed from the [foundation](./environment/foundation) directory, next is day-to-day operations. Most of the time, deployments are decentralized meaning a project is created and handed over to a PI or researcher to be used for their initiatives. Terraform may never be used again to manage the project, but is used for consistency and repeatability.

To build new projects with new infrastructure, these should be built under the [modules](./modules) directory. To seperate out different inputs or to have different environments these will go under the [deployments](./environment/deployments) directory. Additional folders under deployments can be used if desired.

---
## Runbook

### [Foundation Terraform](./runbook/update-foundations.md)

The GCP Organization, Organization Policies, Organization Level IAM, projects, monitoring, and logging are in the Foundation Terraform code and GitHub Actions.Input below for creating folders, modifying IAM roles,and modifiying Projects created by Terraform.  Also below is how to manually create GCP projects in the scratch folder.

## Folders
* [Folder Changes](./runbook/update-foundations.md#example-of-folder-update)

## IAM
* [IAM Role Changes](./runbook/update-foundations.md#example-of-iam-update)
* [Organization Policy Changes](./runbook/update-foundations.md#organization-policy-update)
* [Google Group Changes](./modules/google_groups)

### Projects
* [GCP Service Enable/Disable](./runbook/service-api.md)
* [Manual Creation of New Projects](./runbook/new-projects.md)
* [Terraform Project Modification](./runbook/project-modification.md)
* [Terraform Project Deployment Creation](./environment/deployments)

### [Github Actions](./runbook/github-actions.md)

Overview of Github Actions YAML files and input on how to modify them. 

* [Overview](./runbook/github-actions.md)
* [Creating New Pipelines](./runbook/new-pipelines.md)

### [GKE](./modules/gke)

Input below for working with GKE.

### Connecting to GKE Cluster
* [kubectl](runbook/gcp-access.md#kubectl)
* [GKE VS Cloud Code plugin link](https://marketplace.visualstudio.com/items?itemName=GoogleCloudTools.cloudcode)

#### Monitoring and Logging
* [Viewing Application Logs](runbook/monitoring-logging.md#viewing-gke-application-logs)
* [GCP Monitoring Dashboards](runbook/monitoring-logging.md#monitoring)

#### Node Pools
* [Increase Node Pool Size or Turn Down Nodes](runbook/gke-node.md#increasing-or-decreasing-node-counts)
* [Setting Cluster Monitoring and Logging](runbook/monitoring-logging.md#setting-gke-monitoring-and-logging)

#### Storage
* [Filestore Directory Prep](runbook/filestore.md#filestore-directory-prep)
* [Editing Filestore Instance](runbook/filestore.md#editing-filestore-instance)
* [Persistent Disks Retain](runbook/persistent-disk-retain.md)


### VPC Peering
* [Create a VPC Peer](./runbook/vpc-peering.md)
