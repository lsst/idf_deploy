# Deployments

The purpose of the `Deployments` directory is to deploy new projects.

## Automated Pipelines

GitHub Actions is used as the CI/CD deployment tool. GitHub Actions is connected to the `remote` git repo hosted in client git repo. There are automated pipelines configured in .github/workflows that watch for changes in the different deployments directories.
>Note: Filters for all pipelines have been configured to only watch for changes in the `envrionment/deployments/{application}/env` directory, specifically changes to `tfvars` files.

### Setup

1. Clone repo from GitHub `git clone lsst/idf_deploy.git`
1. Change freshly cloned repo and change to non master branch `git checkout -b simple-project`
1. Create a new folder in the deployments directory with the same name as the branch name `mkdir envrionment\deployments\simple-project`
1. Copy example contents from `modules\{template}\examples` to new folder `cp -r modules/project_iam_vpc/example/simple-project envrionment/deployments/simple-project` (modify accordingly based on your current directory).
1. Update the `terraform.tfvars` file with values from your environment.
1. Commit changes with `git add .` and `git commit -m 'Your message'`
1. Push your non master branch to trigger a plan `git push --set-upstream origin simple-project`
1. Merge the changes to master with `git checkout -b master` and `git push origin master`
1. Delete the branch
