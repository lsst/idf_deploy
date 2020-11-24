# Deployments

The purpose of the `Deployments` directory is to deploy new projects.

## Automated Pipelines

Cloud Build is used as the CI/CD deployment tool and it's enabled in the `Terraform` GCP project. Cloud Build is connected to the `remote` git repo hosted in client git repo. There are 2 automated pipelines configured in Cloud Build that watch for changes in the `central-hpc-terraform` repo.
>Note: Filters for all pipelines have been configured to only watch for changes in the `envrionment/deployments` directory.

1. The first pipeline - Terraform Plan - watches for any changes in the `Deployments` directory that's NOT the master branch. 
2. The second pipeline - Terraform Apply - watches for any changes in the `Deployments` directory that IS the master branch.

### Terraform Plan Pipeline

The first pipeline has a `terraform plan` associated with it, with some additional checks like `terraform fmt`. When the plan pipeline is complete, a `tfplan` output is created and named to match the `branch name`. The `$BRANCH_NAME.tfplan` is upload to a GCS bucket. This `tfplan` is used during the `apply` pipeline.

>Important Note: the folder name in the `Deployments` directory must match the branch name. This is how the pipeline keeps track of the the different branches with the different `tfplans`.

### Terraform Apply Pipeline
The second pipeline has a `terraform apply` associated with it. It will check the tfplan matches with the `$BRANCH_NAME`, if it doesn't it will fail.

## Usage

### Setup to run via Cloud Build

1. Clone repo from Bitbucket `git clone caltechimss/central-hpc-terraform.git`
1. Change freshly cloned repo and change to non master branch `git checkout -b simple-project`
1. Create a new folder in the deployments directory with the same name as the branch name `mkdir envrionment\deployments\simple-project`
1. Copy example contents from `modules\{template}\examples` to new folder `cp -r modules/project_iam_vpc/example/simple-project envrionment/deployments/simple-project` (modify accordingly based on your current directory).
1. Update the `terraform.tfvars` file with values from your environment.
1. Commit changes with `git add .` and `git commit -m 'Your message'`
1. Push your non master branch to trigger a plan `git push --set-upstream origin simple-project`
1. Merge the changes to master with `git checkout -b master` and `git push origin master`
1. Delete the branch
