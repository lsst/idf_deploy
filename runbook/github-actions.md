# Github Actions

A specified event automatically triggers the workflow, which contains a job. The job then uses steps to control the order in which actions are run.

# Overview
The following is an overview of a standard YAML file. 

The specified event that automatically triggers the workflow are pull requests and pushes to the main branch. Any changes to the .tfvars files will be monitored and will trigger the build process to run automatically.

![Picture1](./images/Picture1.png)

A job is a collection of steps to be executed and in this case, it is configure to be Terraform. 

![Picture2](./images/Picture2.png)

Your repository will then be checked out, allowing you to run actions against your code.

![Picture3](./images/Picture3.png)

Authentication to GCP will take place the CLI will will be installed with Terraform.

![Picture4](./images/Picture4.png)

If the push is going to the main branch, terraform fromatting checks will happen and the files will go through the init, validate, plan and apply process. 

![Picture5](./images/Picture5.png)


## Example updated .tfvars file

* Create a new branch. 

![Picture6](./images/Picture6.PNG)

*  On the newly created branch, Update the `.tfvars` file. In the below example, the fileshare capacity is being modified. 
```diff
-   fileshare_capacity = 2000
+   fileshare_capacity = 2500
```
* Commit and push the changes onto the main branch. 

* Merge the pull request from the Pull Request tab.

* View the real time logs from the Actions tab of the build process. 



