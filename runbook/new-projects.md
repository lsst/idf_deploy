**Deploying New Applications**

To follow the current folder structure, each new application will have its own top-level folder. 

In the GCP Console, use the `Select a project` drop down menu from the blue ribbon and click the three dots next to New Project. Then select `Manage Resources`.

Select `Create Folder` and provide the following:
* Folder Name - New application name
* Location - This should be the name of the organization (lsst.cloud) being this is a top-level folder. 

Click `Create`.

<br>

**Deploying Different Environments Per New Applications**

To follow the current folder structure, each new application will have its own top-level folder and sub-folders will further break out the environments into Production, Dev and Intergration. 

In the GCP Console, use the `Select a project` drop down menu from the blue ribbon and click the three dots next to New Project. Then select `Manage Resources`.

Select `Create Folder` and provide the following:
* Folder Name - Either productions, Intergration or Dev.
* Location - This should be the name of the top-level folder that this sub-leve folder will be nested in. 

Click `Create`.

Repeat this process for the remaining environments. 

<br>

**Update Projects and Clusters**

To follow the current folder structure, each new application will have its own top-level folder and sub-folders will further break out the environments. Place newly created projects in the folder structure accordingly. 

In the GCP Console, use the `Select a project` drop down menu on the blue ribbon and click `New Project`.

Fill in the details for:
* Project Name
* Project ID
* Location - Choose the approprite folder to place the project by clicking `Browse`.

Then click `Create`. 


