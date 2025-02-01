resource "azurerm_container_app" "search" {
  for_each = var.search_enabled ? toset(["enabled"]) : toset([])

  name                         = "${module.naming.container_app.name}-search"
  container_app_environment_id = azurerm_container_app_environment.librechat.id
  resource_group_name          = azurerm_resource_group.core.name
  revision_mode                = "Single"

  ingress {
    external_enabled = false
    target_port      = 7700
    transport        = "http"
    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }

  secret {
    name  = "meilimasterkey"
    value = random_string.meilisearch_master_key.result
  }


  template {
    container {
      name   = "meilisearch"
      image  = "getmeili/meilisearch:v1.12.7"
      cpu    = 0.5
      memory = "1Gi"

      env {
        name        = "MEILI_MASTER_KEY"
        secret_name = "meilimasterkey"
      }
      env {
        name  = "MEILI_NO_ANALYTICS"
        value = true
      }

    }
  }
}
