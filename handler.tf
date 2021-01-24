resource "helm_release" "k8s-node-termination-handler" {
  name          = local.helm_handler_chart
  chart         = local.helm_handler_chart
  repository    = local.helm_repo_url
  version       = local.helm_handler_release

  namespace     = kubernetes_namespace.namespace.id
  recreate_pods = true
  force_update  = true

  set {
    name  = "secret.valuesAreBase64Encoded"
    value = true
  }

  set {
    name  = "secret.googleServiceAccountKeyfileJson"
    value = google_service_account_key.key.private_key
  }

  dynamic "set" {
    for_each = var.additional_handler_set
    content {
      name  = set.value.name
      value = set.value.value
      type  = lookup(set.value, "type", null )
    }
  }

  depends_on = [kubernetes_namespace.namespace, google_service_account.service-account]
}
