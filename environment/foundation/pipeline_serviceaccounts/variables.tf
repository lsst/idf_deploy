// QServ Dev GKE
variable "qserv_dev_gke_names" {
  type        = list(string)
  description = "Names of the service accounts to create."
  default     = []
}

// QServ DEV Project
variable "qserv_dev_names" {
  type        = list(string)
  description = "Names of the service accounts to create."
  default     = []
}

// QServ int GKE
variable "qserv_int_gke_names" {
  type        = list(string)
  description = "Names of the service accounts to create."
  default     = []
}

// QServ Int Project
variable "qserv_int_names" {
  type        = list(string)
  description = "Names of the service accounts to create."
  default     = []
}

// Science Platform Demo GKE
variable "rsp_demo_gke_names" {
  type        = list(string)
  description = "Names of the service accounts to create."
  default     = []
}

// Science Platform Demo Project
variable "rsp_demo_names" {
  type        = list(string)
  description = "Names of the service accounts to create."
  default     = []
}

// Science Platform Dev GKE
variable "rsp_dev_gke_names" {
  type        = list(string)
  description = "Names of the service accounts to create."
  default     = []
}

// Science Platform Dev Project
variable "rsp_dev_names" {
  type        = list(string)
  description = "Names of the service accounts to create."
  default     = []
}

// Science Platform Int GKE
variable "rsp_int_gke_names" {
  type        = list(string)
  description = "Names of the service accounts to create."
  default     = []
}

// Science Platform Int
variable "rsp_int_names" {
  type        = list(string)
  description = "Names of the service accounts to create."
  default     = []
}

// EPO INT Project
variable "epo_int_names" {
  type        = list(string)
  description = "Names of the service accounts to create."
  default     = []
}

// EPO PROD Project
variable "epo_prod_names" {
  type        = list(string)
  description = "Names of the service accounts to create."
  default     = []
}

// ALERT DEV Project
variable "alert_dev_names" {
  type        = list(string)
  description = "Names of the service accounts to create."
  default     = []
}

// Billing Account ID
variable "billing_account_id" {
  description = "The billing account id"
  type        = string
}
