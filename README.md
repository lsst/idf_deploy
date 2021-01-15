# Terraform GCP Foundation and Deployment

This code repo is intended to deploy a solid Google Cloud Platform foundation based off of [Google's Cloud security foundation guide](https://services.google.com/fh/files/misc/google-cloud-security-foundations-guide.pdf). This guide provides our opinionated security foundations blueprint and captures a step-by-step view of how to configure and deploy your Google Cloud estate. This document can provide a good reference and starting point because we highlight key topics to consider. In each topic, we provide background and discussion of why we made each of our choices.

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

### [Foundation](./runbook/update-foundations.md)

This will include maintenance of the following:
* Org policies
* Org Groups and Roles
* Logging
* Shared VPC
* Any project under the `Shared Services` Folder

### [New Projects](./runbook/new-projects.md)

This will include the maintenance and creation of new:
* [Applications (Qserv, Science Platform, etc)](https://github.com/lsst/idf_deploy/blob/master/runbook/new-projects.md#deploying-new-applications)
* [Different environments per applications (Prod, Int, Dev)](https://github.com/lsst/idf_deploy/blob/master/runbook/new-projects.md#deploying-different-environments-per-new-applications)
* [Projects and clusters](https://github.com/lsst/idf_deploy/blob/master/runbook/new-projects.md#update-projects-and-clusters)

### [Github Actions](./runbook/pipelines.md)

This will include an overview of Github Actions YAML files and how to modify them. 

### [GKE](./modules/gke)

Instructions below for working with GKE.  The GKE VS Cloud Code plugin is available [here](https://marketplace.visualstudio.com/items?itemName=GoogleCloudTools.cloudcode)

* [Increase Node Pool Size or Turn Down Nodes](runbook/gke-node.md#increasing-or-decreasing-node-counts)
* [Setting Cluster Monitoring and Logging](runbook/monitoring-logging.md#setting-gke-monitoring-and-logging)
* [Reuse Persistent Disks](runbook/persistent-disks.md)

### [VPC Peering](./modules/vpc_peering)

This will include the creation of VPC Network Peering between two networks.

