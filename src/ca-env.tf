resource "azurerm_container_app_environment" "librechat" {
  name                = module.naming.container_app.name
  location            = var.location
  resource_group_name = azurerm_resource_group.core.name
  tags                = local.common_tags
}
