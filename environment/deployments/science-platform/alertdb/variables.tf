variable "project_id" {
  description = "The ID of the project in which resources will be provisioned."
  type        = string
}

variable "labels" {
  description = "Labels to be attached to the buckets"
  type        = map(any)
  default     = {}
}

variable "purge_old_alerts" {
  description = "If true, delete alerts past var.maximum_alert_age automatically."
  type        = bool
  default     = false
}

variable "maximum_alert_age" {
  description = "Maximum age, in days, to persist alerts in the bucket backend. Only used if var.purge_old_alerts is true."
  type        = int
  default     = 28
}

variable "writer_k8s_namespace" {
  description = "Kubernetes namespace holding the Kubernetes ServiceAccount for the writer application"
  type        = string
  default     = "alert-stream-broker"
}

variable "writer_k8s_serviceaccount_name" {
  description = "Name of the Kubernetes ServiceAccount for the writer application"
  type        = string
  default     = "alert-database-writer"
}

variable "reader_k8s_namespace" {
  description = "Kubernetes namespace holding the Kubernetes ServiceAccount for the reader application"
  type        = string
  default     = "alert-stream-broker"
}

variable "reader_k8s_serviceaccount_name" {
  description = "Name of the Kubernetes ServiceAccount for the reader application"
  type        = string
  default     = "alert-database-reader"
}
