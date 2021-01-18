# Filestore

## Editing Filestore Instance

Once deployed a GCP Filestore instance [cannot change tier](https://cloud.google.com/filestore/docs/service-tiers#selecting_a_tier).  A new Filestore instance with the new tier setting must be deployed and data migrated.  

Filestore size can be changed via terraform by the folling the below instructions.

* Navigate to the [terraform deployments directory](../environment/deployments)
* Open either qserv or science platform. Note that during the time of deploment science platform were the only projects requiring filestore.  Then go into env directory.
* Modify the tfvars file.  The naming syntax is `<env>.tfvars`.  For the development project open dev.tfvars.  For the integration project open int.tfvars.
* Perform a pull request to a new branch to edit the tfvars file
* Add the fileshare_capacity value. The example below updates to 3.6 TB.  This will override the default [2.6 TB value for science platform](/environment/deployments/science-platform/main.tf). Snippet below.

```
fileshare_capacity = 3600
```

### Deploying GKE Configuration for Filestore

When a new filestore is provisioned for science platform the NFS directores needs to be created before use from pods in GKE.  The [RSP FILESTORE DIR GitHub Action](/.github/workflows/rsp-filestore-dir.yaml) automates the provisioning of directories by running a Kubernetes job with shell script that runs mkdir -p for each directory.  The job references a NFS storage class, persistent volume, and persistent volume claim for connecting to Filestore.  This is setup using kustomize templates.  A [base directory](/kubernetes-manifests/base/filestore) contains the nfs storage class, persistent volume, persistent volume claim, and job manifests.  An [overlays directory](/kubernetes-manifests/overlays/dev) directory overlays the Filestore IP using kustomize patches.  This allows the base directory to be used in in the future for other use cases.

The RSP FILESTORE DIR GitHub Action is set to run via manual invocation.  It could be automated in the future.  The requirements during the time of deployment were to run exactly once during GKE setup and not ongoing. To run follow the instructions below.

* Navigate to the [IDF Deploy GitHub Actions](https://github.com/lsst/idf_deploy/actions)
* Select RSP FILSTORE DIR on left.  Select Run Worklow
* Populate the GCP Project ID, GKE Cluster, and Filestore.  The filestore name can be obtained by running `gcloud filestore instances list`
* Select Run workflow
