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

Applying this PR will fail with 400 errors about Identity Pools.  This
is happening because you do not yet have a cluster for which Workload
Identity would make sense.  That indicates that we should move the
Workload Identity resource creation into the GKE provisioning tfvars
steps.

However, the project itself will be created.  You will need that project
ID for subsequent steps.

## Service Account creation

The next stage will take place in [the Foundation
configuration](./environment/foundation).  The [Pipeline Serviceaccounts
main.tf](./environment/foundation/pipeline_serviceaccounts/main.tf) will
need GKE and project accounts added, and like everything else here,
basically this boils down to "replace 'dev' with 'demo'", but now
that there is a project ID (e.g. `science-platform-demo-9e05`), you can
plug that in to the `project_roles` definitions.

Additionally,
[outputs.tf](./environment/foundation/pipeline_serviceaccounts/main.tf),
[variables.tf](./environment/foundation/pipeline_serviceaccounts/), and
[terraform.tfvars](./environment/foundation/pipeline_serviceaccounts/terraform.tfvars)
will require the addition of variables describing your new environment.
You should also update
[readme.md](./environment/foundation/pipeline_serviceaccounts/) with the
new service accounts and email addresses you are creating.  All of this
is just "copy an existing definition and replace the environment name".

Check this PR; when "Terraform plan" gives what look like the right
results, merge it.

## Key transplantation

At this point a project administrator will need to temporarily enable
the ability to extract service account keys.  The two service accounts
just created should have their keys extracted and put into Github
secrets, as something like `PIPELINE_RSP_DEMO_PROJECT` and
`PIPELINE_RSP_DEMO_GKE`.

This is not the pattern we ultimately want.  A future set of
improvements to [idf_deploy](.) will replace this with [keyless
authentication](https://cloud.google.com/blog/products/identity-security/enabling-keyless-authentication-from-github-actions).


## Add additional resources

Do the same for the additional resources you plan to deploy.  For a
minimal Science Platform, start with [the dev GKE
file](./environment/deployments/science-platform/dev-gke.tfvars),
and copy it to [the demo GKE
file](./environment/deployments/science-platform/demo-gke.tfvars).  This
one is simper: all you need to do is replace the environment name and
reset the serial, assuming your base and target environment have similar
sets of resource requirements.

Repeat the process with [cloudSQL
resources](./environment/deployments/science-platform/demo-gke.tfvars),
where you will also need to update `project_id`.  I did not need a
butler database yet, so I commented out that section as well.  The org
policy will have to be manually removed and re-added if a butler
registry is needed: the process is remove, make change, reenable.

If you want other resources (or you are adding something besides a
science platform instance, which has different requirements), edit those
files in an analogous manner.

Again, create a PR, examine the Terraform output, and when happy, merge
the PR.

## Descope GitHub Action accounts

Go back to the [Workflows](.github/workflows) and update the `proj` and
`gke` workflows to use the new keys just created, rather than
`GOOGLE_CREDENTIALS`.

Merge this PR.  (If you do this earlier, the resource creation will not
happen as it should, because the SAs don't have correct permissions.)

## Issues

Looks like the reduced-scope tokens lack some permissions.  The base env
is having permission errors creating a cluster-scoped SA, and cloudsql
fails with "Identity Pool does not exist" which I believe to come from
the failures in the base, because we saw them earlier...but that was
when we didn't have a cluster.

That's because the service account needs the Service Account Admin
permissions.  For the moment, modify it manually, and it goes on the
backlog of stuff we need to fix.
