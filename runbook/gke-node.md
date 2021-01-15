# GKE Node Pools Terraform


## Increasing or Decreasing Node Counts
Below are instructions for increasing or decreasing the GKE node count.  The GKE node count in dev or integration clusters can be reduced when not used to reduce costs.

* Navigate to the [terraform deployments directory](../environment/deployments)
* Open either qserv or science platform. Then go into env directory.
* Modify the tfvars file.  The naming syntax is `<env>-<gke>.tfvars`.  For development clusters open dev-gke.tfvars.  For integration open int-gke.tfvars.
* Perform a pull request to a new branch to edit the gke tfvars file
* Edit the node count value for each node pool you want to increase or decrease. To turn down node pool completely enter 0 for node count.  Snippet below.

```
node_pools = [
  {
    .....
    node_count         = 0
  }
```
* Save and check in the file to GitHub.  An automated GitHub Action will now run to perform a terraform plan to check syntax and formatting of the change. The GitHub Actions for GKE end with GKE.  Example is QServ DEV GKE. Navigate to the [Actions](https://github.com/lsst/idf_deploy/actions) to watch that status.
* Once the GitHub Action worklow runs successfully approve the pull request.  The same GitHub Action will now run with terraform apply.

##  Adding Node Pools