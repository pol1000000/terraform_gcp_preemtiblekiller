locals {
  helm_repo_url        = "https://helm.estafette.io"
  helm_repo_name       = "estafette"

  name_killer          = "gke-preemptible-killer"
  name_killer_id       = local.name_killer
  helm_killer_chart    = "${local.helm_repo_name}-${local.name_killer}"
  helm_killer_release  = var.helm_killer_release

  name_handler         = "k8s-node-termination-handler"
  name_handler_id      = local.name_handler
  helm_handler_chart   = local.name_handler
  helm_handler_release = var.helm_handler_release

  gcloud_role_name     = "preemptiblevmskillerandhandler"
}

# common resources
resource "kubernetes_namespace" "namespace" {
  metadata {
    annotations = {
      name = local.helm_repo_name
    }
    name = local.helm_repo_name
  }
}

resource "google_service_account" "service-account" {
  account_id   = local.gcloud_role_name
  display_name = local.gcloud_role_name
}

resource "google_project_iam_custom_role" "iam-role" {
  role_id     = local.gcloud_role_name
  title       = local.gcloud_role_name
  permissions = ["compute.instances.delete"]
  description = "Delete compute preemptible instances into k8s"
}

resource "google_project_iam_binding" "role_to_project" {
  members = ["serviceAccount:${google_service_account.service-account.email}",]
  role = google_project_iam_custom_role.iam-role.id

  depends_on = [google_service_account.service-account, google_project_iam_custom_role.iam-role]
}

resource "google_service_account_key" "key" {
  service_account_id = google_service_account.service-account.name
  private_key_type   = "TYPE_GOOGLE_CREDENTIALS_FILE"

  depends_on         = [google_project_iam_binding.role_to_project]
}
