# Repo Structure

```
(top-folder)
└── cloudbuild
└── environment
    └── deployments
        └── projects
            ├── new-project.tfvars
            └── new-project-sharedvpc.tfvars
    └── foundation
        └── ...
└── modules
    ├── project_iam_sharedvpc
    └── project_iam_vpc
        ├── main.tf
        ├── variables.tf
        └── ...

```

## Modules Repo

The `modules` repo is where the blueprints of the infrastructure are stored. 

## Deployments Repo

In the `deployments` repo, each environment (workspace) is defined with reference to the set of modules that make up the environment. Typically, these can be a copy-and-paste with some slight differences, like changing project name or labels. The `deployments` does not contain any `*.tf` files, just `*.tfvars` that contain references to the the required modules and defined configuration variables to build and deploy the infrastructure.

## Cloud Build Triggers

Three Cloud Build triggers are provided to help create the correct trigger with the appropriate substitution variables. This code is located in the `foundation\0-bootstrap\cloudbuildops` directory. Terraform State may not be a concern, so you can run Terraform locally from this directory. After `terraform apply`, there will be 3 new triggers.

* project-apply
* project-destroy
* project-plan

## Usage

Cloud Build triggers are used to help to deploy the infrastructure. Substituion variables are used to help fascilitate what module to use and what deployment to reference.

To control what module to use and what deployment to reference, update the `modules_dir` variable with the correct directory name and update the `deployment_dir` with the correct directory name.

### Example

To create a single GCP project with IAM and a custom VPC. This desired build is provided for us under the `modules\project_iam_vpc` directory. 
1. In a Cloud Build Trigger, update the substituion value for the variable `_MODULE_DIR` with `project_iam_vpc`. 
1. The deployment that we want to use is provided for us under the `environments\deployments` directory. In the same Cloud Build Trigger, update the substition value for the variable `_DEPLOYMENT_DIR` to `projects`.
1. The environment (workspace) containing the desired configuration, we need to update the substituion value for the variable `_TFVARS_NAME` to `new-project` (remember to leave off .tfvars)
