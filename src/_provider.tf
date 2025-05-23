terraform {

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.24.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.7.1"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.2.0"
    }
  }

  required_version = "1.11.3"

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

provider "cloudflare" {
  #api_token = var.cloudflare_api_token
}
