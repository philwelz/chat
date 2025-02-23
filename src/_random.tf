resource "random_string" "creds_key" {
  length  = 64
  lower   = true
  upper   = false
  special = false
}

resource "random_string" "creds_iv" {
  length  = 32
  lower   = true
  upper   = false
  special = false
}

resource "random_string" "cosmosdb_root_password" {
  length  = 32
  lower   = true
  upper   = false
  special = false
}

resource "random_string" "jwt_secret" {
  length  = 64
  lower   = true
  upper   = false
  special = false
}

resource "random_string" "jwt_refresh_secret" {
  length  = 64
  lower   = true
  upper   = false
  special = false
}

resource "random_string" "meilisearch_master_key" {
  length  = 32
  special = false
}
