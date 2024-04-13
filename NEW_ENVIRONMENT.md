# Adding a new environment

Adding a new environment to the IDF is a fairly complex process, mostly
because there's a lot of bootstrapping required.

## Set up new folders

The first step is to create a PR to the
[idf_deploy](https://github.com/lsst/idf_deploy) repository adding the
new environment to the [foundation 1-org-b
tfvars](./environment/foundation/1-org-b.tfvars) list.

Note that this is a list rather than a set.  Do not be tempted to add
your environment in the logical place (whether that's alphabetical, or
in sorted importance order, least to most).  If you change any of the
already-present list items, what you will do is rename existing
environments, and great sadness and confusion will arise.  Your new
environment goes at the bottom.

Edit
[this](https://github.com/lsst/idf_deploy/blob/d2f5f83d4c268b003df57106b74c623b98d586b0/environment/foundation/1-org-b/1-org-b.tfvars#L4-L12)
data structure.

Create a PR, carefully read the outcome of "Terraform Plan" when the
build action runs, correct the PR if necessary, and when it is only
creating new folders and not modifying anything new, merge it.

## Set up new Github Actions

Next you will create a PR to add new actions for each of the items
you will want to create in your new project.  Go to the [Github Actions
Directory](./.github/workflows), pick the thing that is most like the
environment you wish to create (in my case, the Dev RSP was the most
like the Demo RSP I was building), and copy and edit all the files to
reflect the new name you want.  In the case of the RSP, you will create
YAML files for each of:
* alertdb
* cloudsql
* firestore
* gke
* proj

(You may not need all of these, but you will certainly want all of
`cloudsql`, `gke`, and `proj`.)

Change the existing environment name to the new environment name.

Finally, as part of the bootstrapping process, rather than renaming, for
instance, the service key whose value is (in the source environment)
`${{ secrets.PIPELINE_RSP_DEV_PROJECT }}`, that will need to be
`${{ secrets.GOOGLE_CREDENTIALS }}` for the moment.  That's because you
haven't created the project or any of its associated service accounts
and security keys yet, so it's necessary to bootstrap with broader
admin credentials.

Once again, test this PR by making sure the `Terraform plan` output
looks OK, and then merge the PR.

## Set up environment tfvars

