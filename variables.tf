# killer params
variable "whitelist_hours" {
  type        = list(string)
  default     = []
  description = "(Optional) List of UTC time intervals in which deletion is allowed and preferred, e.g. [\"22:00 - 04:00\"]"
}

variable "blacklist_hours" {
  type        = list(string)
  default     = []
  description = "(Optional) List of UTC time intervals in which deletion is NOT allowed, e.g. [\"04:00 - 12:00\", \"13:00 - 22:00\"]"
}

variable "drain_timeout" {
  default     = "300"
  description = "(Optional) Max time in second to wait before deleting a node"
}

variable "interval_checks" {
  default     = "600"
  description = "(Optional) Time in second to wait between each node check"
}

variable "additional_killer_set" {
  default     = []
  description = "Add additional set for helm_killer_chart. refs: https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release#set"
}

variable "helm_killer_release" {
  default     = "1.2.6"
  description = "https://github.com/estafette/estafette-gke-preemptible-killer/releases"
}
# helm repo add Estafette https://helm.estafette.io/ && helm repo update && helm search estafette-gke-preemptible-killer -l

# handler params
variable "additional_handler_set" {
  default     = []
  description = "Add additional set for helm_handler_chart. refs: https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release#set"
}

variable "helm_handler_release" {
  default     = "0.1.2-main-11"
  description = "https://github.com/estafette/k8s-node-termination-handler"
}
# helm repo add Estafette https://helm.estafette.io/ && helm repo update && helm search k8s-node-termination-handler -l
