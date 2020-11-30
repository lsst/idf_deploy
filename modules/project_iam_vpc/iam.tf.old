module "project-iam-bindings" {
  source   = "terraform-google-modules/iam/google//modules/projects_iam"
  version  = "~> 6.0"
  projects = [module.project.project_id]
  mode     = var.mode

  bindings = {
    "${var.group_name_binding}" = [
      "group:${var.group_name}",
    ]
  }
}

