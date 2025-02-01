resource "azurerm_cognitive_account" "openai" {
  name                = module.naming.cognitive_account.name
  location            = var.location
  resource_group_name = azurerm_resource_group.core.name
  kind                = "OpenAI"
  sku_name            = "S0"
}

resource "azurerm_cognitive_deployment" "azure_openai_models" {
  for_each = {
    for model in var.azure_openai_models : model.name => model
  }

  name                   = each.value.name
  cognitive_account_id   = azurerm_cognitive_account.openai.id
  version_upgrade_option = "OnceNewDefaultVersionAvailable"

  model {
    format  = "OpenAI"
    name    = each.value.name
    version = each.value.version
  }

  sku {
    name     = "GlobalStandard"
    capacity = each.value.rate_limit_per_minute_in_thousand
    # tier = "Standard"
    # size = "S0"

  }
}
