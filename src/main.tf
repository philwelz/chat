################################
# Resource Groups
################################

resource "azurerm_resource_group" "core" {
  name     = module.naming.resource_group.name
  location = var.location
  tags     = local.common_tags
}


################################
# Fetch Information
################################

data "azurerm_client_config" "current" {
}
