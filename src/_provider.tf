terraform {

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.14.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "=3.6.3"
    }
    time = {
      source  = "hashicorp/time"
      version = "=0.12.1"
    }
    local = {
      source  = "hashicorp/local"
      version = "=2.5.2"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.51.0"
    }
  }

  required_version = "=1.10.4"

  backend "azurerm" {
  }
}

provider "azurerm" {
  features {}
  resource_provider_registrations = "extended"
  resource_providers_to_register = [
    "Microsoft.App"
  ]
}

provider "azuread" {
  # Configuration options
}

provider "cloudflare" {
  #api_token = var.cloudflare_api_token
}
