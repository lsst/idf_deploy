# Terraform GitHub Actions
GitHub Actions to deploy GCP Foundation 

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
| RSP FILESTORE DIR               | rsp-filestore-dir.yaml              | Manual Invokation| Creates Filestore PV, PVC, Storage Class and NFS dirs       |
| QSERV DEV GCP PROJECT           | qserv-dev-proj-tf.yaml              | tfvars Pull/Push | Creates dev qserv GCP Project, setups billing               |
| QSERV DEV GKE                   | qserv-dev-gke-tf.yaml               | tfvars Pull/Push | Creates and manages settings on qserv dev GKE Cluster       |
| QSERV INT GCP PROJECT           | qserv-int-proj-tf.yaml              | tfvars Pull/Push | Creates dev qserv GCP Project, setups billing               |
| QSERV INT GKE                   | qserv-int-gke-tf.yaml               | tfvars Pull/Push | Creates and manages settings on qserv int GKE Cluster       |
| QSERV STABLE GCP PROJECT        | qserv-stable-proj-tf.yaml           | tfvars Pull/Push | Creates prod qserv GCP Project, setups billing              |
| QSERV STABLE GKE                | qsrv-stable-gke-tf.yaml             | tfvars Pull/Push | Creates and manages settings on qserv prod GKE Cluster      |


## Filestore Directory Creation

Run the [RSP FILESTORE DIR](file://rsp-filestore-dir.yaml) workflow once a GKE cluster is built to create the GCP persistent volume, storage class, persistent volume claim, and a job that mounts the volume to create the NFS directories.  The code is [here](file://./kubernetes-manifests)  Kustomize is used to build the kubernetes yaml for deployment. The structure is setup so that in the future if there are other components that need setup they can use the kustomize directory structure. 

The worklow is setup for manual invokation.  A fully automated workflow was considered for the filestore dirs setup to run after the terraform GKE pipeline.  This approach was not used because the Filestore Directory Creation is a one time setup item and the terraform GKE pipelines will be run ongoing to modify things like node pool configuration.  

To manually invoke in GitHub Actions select workflow > Run Workflow.  Enter in the project ID, GKE Cluster, and Filestore instance which you wish to configure.  To obtain the filestore name run 'gcloud filestore instances list' in the selected project.  Selecting the filestore instance is here in case multiple filestore instances are created in the future and wrong one is not inadvertenly configured.