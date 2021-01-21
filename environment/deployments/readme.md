# Deployments

The purpose of the `Deployments` directory is to deploy new projects.

## Automated Pipelines

GitHub Actions is used as the CI/CD deployment tool. GitHub Actions is connected to the `remote` git repo hosted in client git repo. There are automated pipelines configured in .github/workflows that watch for changes in the different deployments directories.
>Note: Filters for all pipelines have been configured to only watch for changes in the `envrionment/deployments/{application}/env` directory, specifically changes to `tfvars` files.

### Setup

1. Clone repo from GitHub `git clone lsst/idf_deploy.git`
1. Change freshly cloned repo and change to non master branch `git checkout -b simple-project`
1. Create a new folder in the deployments directory `mkdir envrionment\deployments\example-project`
1. Start by creating the `main.tf`, `variables.tf`, `outputs.tf`, `readme.md`, and an `\env` subdirectory.
>Note: Our environment specifics will go under the `\env` folder in a `{environment}.tfvars` file name.
1. Create the desired infrastructure using the pre-build modules in the [modules](./) directory.
>Note: New modules normally go into the `main.tf` file. Variables go into the `variables.tf` file.
1. Copy desired modules from the `modules\` directory into the appropriate `.tf` files.
1. Update the `terraform.tfvars` file in the `\env` folder with values for your environment.
1. Commit changes with `git add .` and `git commit -m 'Your message'`
1. Push your non master branch to trigger a plan `git push --set-upstream origin simple-project`
1. Merge the changes to master with `git checkout -b master` and `git push origin master`
1. Delete the branch
