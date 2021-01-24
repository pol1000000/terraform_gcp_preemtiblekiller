resource "helm_release" "k8s-preemptible-vms-killer" {
  name          = local.helm_killer_chart
  chart         = local.helm_killer_chart
  repository    = local.helm_repo_url
  version       = local.helm_killer_release

  namespace     = kubernetes_namespace.namespace.id
  recreate_pods = true
  force_update  = true

  dynamic "set" {
    iterator = time
    for_each = var.whitelist_hours
    content {
      name  = "extraEnv.WHITELIST_HOURS"
      value = replace(time.value, ",", "\\,")
    }
  }

  dynamic "set" {
    iterator = time
    for_each = var.blacklist_hours
    content {
      name  = "extraEnv.BLACKLIST_HOURS"
      value = replace(time.value, ",", "\\,")
    }
  }

  set {
    name  = "drainTimeout"
    value = var.drain_timeout
  }

  set {
    name  = "interval"
    value = var.interval_checks
  }

  set {
    name  = "secret.valuesAreBase64Encoded"
    value = true
  }

  set {
    name  = "secret.googleServiceAccountKeyfileJson"
    value = google_service_account_key.key.private_key
  }

  dynamic "set" {
    for_each = var.additional_killer_set
    content {
      name  = set.value.name
      value = set.value.value
      type  = lookup(set.value, "type", null )
    }
  }

  depends_on = [kubernetes_namespace.namespace, google_service_account.service-account]
}
