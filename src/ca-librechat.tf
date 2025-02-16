
resource "azurerm_container_app" "librechat" {
  name                         = module.naming.container_app.name
  container_app_environment_id = azurerm_container_app_environment.librechat.id
  resource_group_name          = azurerm_resource_group.core.name
  revision_mode                = "Single"
  tags                         = local.common_tags

  ingress {
    external_enabled = true
    target_port      = 3080
    transport        = "http"
    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }

  secret {
    name  = "mongouri"
    value = azurerm_cosmosdb_account.librechat.primary_mongodb_connection_string
  }

  secret {
    name  = "credskey"
    value = random_string.creds_key.result
  }

  secret {
    name  = "credsiv"
    value = random_string.creds_iv.result
  }

  secret {
    name  = "jwtsecret"
    value = random_string.jwt_secret.result
  }

  secret {
    name  = "jwtrefreshsecret"
    value = random_string.jwt_refresh_secret.result
  }

  secret {
    name  = "openaikey"
    value = var.openai_api_key
  }

  secret {
    name  = "ghclientsecret"
    value = var.github_client_secret
  }

  dynamic "secret" {
    for_each = var.search_enabled == true ? [1] : []
    content {
      name  = "meilimasterkey"
      value = random_string.meilisearch_master_key.result
    }
  }

  secret {
    name  = "azureopenaikey"
    value = azurerm_cognitive_account.openai.primary_access_key

  }

  template {
    container {
      name   = "librechat"
      image  = "ghcr.io/danny-avila/librechat:${var.librechat_version}"
      cpu    = 1
      memory = "2Gi"

      ###########################################
      # Common
      ###########################################

      dynamic "env" {
        for_each = local.chat_env_vars
        content {
          name  = env.key
          value = env.value
        }
      }

      ###########################################
      # Local
      ###########################################

      env {
        name        = "CREDS_KEY"
        secret_name = "credskey"
      }
      env {
        name        = "CREDS_IV"
        secret_name = "credsiv"
      }

      # Creds for JWT
      env {
        name        = "JWT_SECRET"
        secret_name = "jwtsecret"
      }
      env {
        name        = "JWT_REFRESH_SECRET"
        secret_name = "jwtrefreshsecret"
      }

      ###########################################
      # MongoDb
      ###########################################

      # Specifies the MongoDB URI.
      env {
        name        = "MONGO_URI"
        secret_name = "mongouri"
      }

      ###########################################
      # MongoDb
      ###########################################

      env {
        name  = "ENDPOINTS"
        value = join(", ", local.librechat_endpoints)
      }

      ###########################################
      # OpenAI
      ###########################################

      # Your OpenAI API key.
      dynamic "env" {
        for_each = var.azure_openai_enabled == true ? [1] : []
        content {
          name        = "OPENAI_API_KEY"
          secret_name = "openaikey"
        }
      }

      dynamic "env" {
        for_each = var.azure_openai_enabled == true ? [1] : []
        content {
          name        = "OPENAI_MODELS"
          secret_name = join(",", [for model in var.openai_models : model.name])
        }
      }

      dynamic "env" {
        for_each = var.azure_openai_enabled == true ? [1] : []
        content {
          name        = "OPENAI_MODERATION"
          secret_name = false
        }
      }

      ###########################################
      # Azure OpoenAI
      ###########################################

      dynamic "env" {
        for_each = var.azure_openai_enabled == true ? [1] : []
        content {
          name        = "AZURE_API_KEY"
          secret_name = "azureopenaikey"
        }
      }

      dynamic "env" {
        for_each = var.azure_openai_enabled == true ? [1] : []
        content {
          name  = "AZURE_OPENAI_MODELS"
          value = join(",", [for model in var.azure_openai_models : model.name])
        }
      }

      dynamic "env" {
        for_each = var.azure_openai_enabled == true ? [1] : []
        content {
          name  = "AZURE_USE_MODEL_AS_DEPLOYMENT_NAME"
          value = true
        }
      }

      dynamic "env" {
        for_each = var.azure_openai_enabled == true ? [1] : []
        content {
          name  = "AZURE_OPENAI_API_INSTANCE_NAME"
          value = var.location
        }
      }

      dynamic "env" {
        for_each = var.azure_openai_enabled == true ? [1] : []
        content {
          name  = "AZURE_OPENAI_API_VERSION"
          value = var.azure_openai_api_version
        }
      }

      ###########################################
      # Search
      ###########################################

      dynamic "env" {
        for_each = var.search_enabled == true ? [1] : []
        content {
          name  = "SEARCH"
          value = true
        }
      }

      dynamic "env" {
        for_each = var.search_enabled == true ? [1] : []
        content {
          name        = "MEILI_MASTER_KEY"
          secret_name = "meilimasterkey"
        }
      }

      dynamic "env" {
        for_each = var.search_enabled == true ? [1] : []
        content {
          name  = "MEILI_NO_ANALYTICS"
          value = true
        }
      }

      dynamic "env" {
        for_each = var.search_enabled == true ? [1] : []
        content {
          name  = "MEILI_HOST"
          value = "https://${azurerm_container_app.search["enabled"].ingress[0].fqdn}"
        }
      }

      ###########################################
      # Authentication - GitHub
      ###########################################

      env {
        name        = "GITHUB_CLIENT_SECRET"
        secret_name = "ghclientsecret"
      }

    }
  }
}

resource "azurerm_container_app_custom_domain" "librechat" {
  name             = "${var.host}.${var.custom_domain}"
  container_app_id = azurerm_container_app.librechat.id

  lifecycle {
    // When using an Azure created Managed Certificate these values must be added to ignore_changes to prevent resource recreation.
    ignore_changes = [certificate_binding_type, container_app_environment_certificate_id]
  }
}
