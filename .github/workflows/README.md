# Terraform GitHub Actions
Workflows GitHub Actions are configured to deploy organization level settings, folders, projects, Google Kubernetes Engine, and Filestore.  Terraform state is stored in the lsst-terraform-state Google Cloud Storage Bucket.  Each Workflow below has its own prefix to seperate state files. All terraform init, plan, and apply is performed using GitHub Actions so there is no need to run Terraform outside of GitHub Actions to make changes.  

| Workflow                        | File                                | Trigger Type     | Description                                                 |
|---------------------------------|-------------------------------------|------------------|-------------------------------------------------------------|
| GCP Organization Level Settings | terraform-foundation-1-org.yaml     | tfvars Pull/Push | Applies org level settings like log sink and org policies   |
| GCP Folders                     | terraform-foundation-1-org-b.yaml   | tvvars Pull/Push | Builds Folder Structure                                     |
| GCP Network Foundation          | terraform-foundation-2-network.yaml | tfvars Pull/Push | Builds custom VPC and and Shared VPC                        | 
| RSP DEV GCP Project             | rsp-dev-proj-tf.yaml                | tfvars Pull/Push | Creates dev rsp GCP Project, setups billing, NFS            |
| RSP DEV GKE                     | rsp-dev-gke-tf.yaml                 | tfvars Pull/Push | Creates and manages settings on rsp prod GKE Cluster        |
| RSP INT GCP Project             | rsp-int-proj-tf.yaml                | tfvasr Pull/Push | Creates int rsp GCP Project, setups billing, NFS            | 
| RSP INT GKE                     | rsp-int-gke-tf.yaml                 | tfvars Pull/Push | Creates and manages settings on rsp int GKE Cluster         |
| RSP STABLE GCP PROJECT          | rsp-stable-proj-tf.yaml             | tfvars Pull/Push | Creates prod rsp GCP Project, setups billing, NFS           |
| RSP STABLE GKE                  | rsp-stable-gke-tf-yaml              | tfvars Pull/Push | Creates and manages settings on prod GKE Cluster            |
| RSP FILESTORE DIR               | rsp-filestore-dir.yaml              | Manual Invocation| Creates Filestore PV, PVC, Storage Class and NFS dirs       |
| QSERV DEV GCP PROJECT           | qserv-dev-proj-tf.yaml              | tfvars Pull/Push | Creates dev qserv GCP Project, setups billing               |
| QSERV DEV GKE                   | qserv-dev-gke-tf.yaml               | tfvars Pull/Push | Creates and manages settings on qserv dev GKE Cluster       |
| QSERV INT GCP PROJECT           | qserv-int-proj-tf.yaml              | tfvars Pull/Push | Creates dev qserv GCP Project, setups billing               |
| QSERV INT GKE                   | qserv-int-gke-tf.yaml               | tfvars Pull/Push | Creates and manages settings on qserv int GKE Cluster       |
| QSERV STABLE GCP PROJECT        | qserv-stable-proj-tf.yaml           | tfvars Pull/Push | Creates prod qserv GCP Project, setups billing              |
| QSERV STABLE GKE                | qsrv-stable-gke-tf.yaml             | tfvars Pull/Push | Creates and manages settings on qserv prod GKE Cluster      |

## Creating new workflows
When creating a new Google GCP project, two pipelines are normally needed. These two pipelines help reduce the blast radius as well as create different [Terraform State](https://www.terraform.io/docs/state/index.html) files.

1. A pipeline that deploys and maintains `project` related stuff like the project itself, attached billing accounts, IAM permissions, filestore, etc. Anything that's not Kubernetes specific.
1. A pipeline to create and maintain the Kubernetes cluster.

### Usage
Below is a simple example of re-using an existing workflow and modifying to be used for a new application:

* We'll use the `qserv-int-proj-tf.yaml` as an example to be used to create a new pipeline to create and manage a new application in the [environments/deployments](../../environments/deployments) directory. Copy and rename it to something like {app}-{env}-proj.tf.yaml.
```diff
- qserv-int-proj-tf.yaml
+ panda-dev-proj-tf.yaml
```

* We need to make our new workflow unique and change the paths of the working directories for [Terraform to initialize](https://www.terraform.io/docs/commands/init.html). Search and replace the following:

```diff
- name: 'QServ INT GCP Project'
+ name: 'PanDa DEV GCP Project`

- 'environment/deployments/qserv/env/integration.tfvars'
+ 'environment/deployments/panda/env/dev.tfvars'

- working-directory: ./environment/deployments/qserv
+ working-directory: ./environment/deployments/panda
```

* (Optional) Update any of the Terrform specifics like `terraform_version`, or the path to the `tfvars` file.


## Deploying GCP Projects

GCP Projects are deployed via Terraform.  

There is one GCP billing account for Rubin Observatory.  That billing account is statically linked in Terraform since it does not change.


## Deploying GKE with Kubernetes

During testing a bug was discovered with Terraform 0.13 function in deploying GKE.  There was a higher level issue in Terraform with count that we ran into when deploying multiple node pools.  [This](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/690) is the bug

The following examples are changes that can be made in Terraform without destroying the GKE Cluster.

* Addition or removal of Node Pools
* Changing Node Pool settings.  Please note that the Node Pool itself will be deleted if changed so will affect pods running on the nodes.
* Enabling of Autoscaling on Node Pools
* Changing of Maintenance Window
* Change of Release

## VPC Peering

VPC Peering is setup between the Science Platform and QServ projects. (update)

## Filestore Directory Creation

Run the [RSP FILESTORE DIR](rsp-filestore-dir.yaml) workflow once a GKE cluster is built to create the GCP persistent volume, storage class, persistent volume claim, and a job that mounts the volume to create the NFS directories.  The code is [here](/kubernetes-manifests)  Kustomize is used to build the kubernetes yaml for deployment. The structure is setup so that in the future if there are other components that need setup they can use the kustomize directory structure. 

The worklow is setup for manual invocation.  A fully automated workflow was considered for the filestore dirs setup to run after the terraform GKE pipeline.  This approach was not used because the Filestore Directory Creation is a one time setup item and the terraform GKE pipelines will be run ongoing to modify things like node pool configuration.  

To manually invoke in GitHub Actions select workflow > Run Workflow.  Enter in the project ID, GKE Cluster, and Filestore instance which you wish to configure.  To obtain the filestore name run `gcloud filestore instances list` in the selected project.  Selecting the filestore instance is here in case multiple filestore instances are created in the future and wrong one is not inadvertenly configured.

### Kustomize

Kustomize is used to deploy the kubernetes manifests for persistent volume, volume claim, storage class, and job.  The [kubernetes manifests](/kubernetes-manifests) directory in this repository contains a [base directory](/kubernetes-manifests/base/filestore) and an [overlay](/kubernetes-manifests/overlays/) directory to patches.  At this time the only patch is setting the filestore IP.  The Filestore IP is queried using gcloud and the instance name provided during manual invocation.  KQ is then used to update the nfs.ip.patch.yaml IP address to the Filestore IP.

Kustomize is preinstalled on GitHub Actions.  The Kustomize version is 3.8.7 during the GitHub Actions setup. 