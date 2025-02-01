resource "azurerm_cosmosdb_account" "librechat" {
  name                              = module.naming.cosmosdb_account.name
  resource_group_name               = azurerm_resource_group.core.name
  location                          = var.location
  offer_type                        = "Standard"
  kind                              = "MongoDB"
  automatic_failover_enabled        = false
  free_tier_enabled                 = false
  mongo_server_version              = "7.0"
  is_virtual_network_filter_enabled = false
  public_network_access_enabled     = true
  ip_range_filter = [
    "0.0.0.0",
    "13.91.105.215",
    "4.210.172.107",
    "13.88.56.148",
    "40.91.218.243",
    "20.245.81.54",
    "40.118.23.126",
    "40.80.152.199",
    "3.95.130.121",
  ]

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 10
    max_staleness_prefix    = 200
  }

  geo_location {
    location          = var.location
    failover_priority = 0
  }

  capabilities {
    name = "EnableServerless"
  }
  capabilities {
    name = "EnableMongo"
  }

  #   virtual_network_rule {
  #     id = azurerm_subnet.cosmosdb.id
  #   }


}
