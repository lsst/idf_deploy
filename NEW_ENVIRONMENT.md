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

## Set up initial environment tfvars

Decide which [environment](./environment/deployments) you need to
modify.  In my case it's the [Science
Platform](./environment/deployments/science-platform).  You will
effectively be performing the same set of operations you did with the
GitHub Actions: copy an existing environment and change it to fit.

You must start with the base environment file, as this will create the
project that will give you a project ID you will need for all the rest
of the environment files.

This and the following instructions will only be correct for adding a
new Science Platform deployment.  Other types of environment
(e.g. qserv) will be analogous, but specifics will differ.

### Editing the base file

I'm creating a `demo` environment from `dev`, so:

* the first step is to copy
  [the dev base file](./environment/deployments/science-platform/dev.tfvars) to 
  [the demo base
  file](./environment/deployments/science-platform/dev.tfvars)
* Second, reset the serial number to `1` at the bottom.  Not, strictly
  speaking, needed, but it would be sloppy not to.
* Next, change the string `dev` to `demo` everywhere inside it.
* Fourth, replace the folder ID at the top with the ID from the folder
  that was created when you applied the first PR.
* Finally, pick new subnets that are not yet in use.  You're going to
  need two.  They start at `10.128.0.0/23`, and the next unused one is
  (at the time of writing) `10.168.0.0/23`.  It is necessary to search
  all the environments, not just the type you're creating, to determine
  what is first unused (that is, all the projects, qserv, roundtable,
  whatever, each have their own subnets).  The first one becomes the
  `subnet_ip` key for the first subnet.  The `secondary_ranges` subnet
  should increase the second octet by one and use the entire 16 bits of
  possible address space (so, for instance, if you picked
  `10.168.0.0/23` for `subnet_ip`, the `kubernetes-pods` should get
  `10.169.0.0/16`.  The `kubernetes-services` range should use the
  *first* subnet range, but the third octet should be `16` and the width
  should be `20`: in this example, `10.168.16.0/20`.

## Additional tfvars files

Do the same for the GKE file (in this case, I would start with [the dev
GKE file](./environment/deployments/science-platform/dev-gke.tfvars),
and copy it to [the demo GKE
file](./environment/deployments/science-platform/demo-gke.tfvars).  This
one is simper: all you need to do is replace the environment name and
reset the serial, assuming your base and target environment have similar
sets of resource requirements.

Again, create a PR, examine the Terraform output, and when happy, merge
the PR.



