locals {
  project_id = data.terraform_remote_state.snd_project.outputs.project_id
  snd_hostname = var.snd_hostname
}
