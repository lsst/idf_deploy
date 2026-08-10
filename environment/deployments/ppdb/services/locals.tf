locals {
  project_id = data.terraform_remote_state.ppdb_project.outputs.project_id

  sql_instance_name = data.terraform_remote_state.ppdb_cloud_sql.outputs.ppdb_cloud_sql_instance_name

  network = replace(
          data.terraform_remote_state.ppdb_project.outputs.network_self_link,
          "https://www.googleapis.com/compute/v1/",
          ""
        )
  subnet = replace(
      one([
        for s in data.terraform_remote_state.ppdb_project.outputs.subnets_self_links : s
        if can(regex("subnet-us-central1-01", s))
      ]),
      "https://www.googleapis.com/compute/v1/",
      ""
    )
}
