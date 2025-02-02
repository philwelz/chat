################################
# Common
################################

variable "stage" {
  description = "(Required) The suffix for the resources created in the specified environment"
  default     = "openai"
}

variable "location" {
  description = "The location used for all resources"
  type        = string
  default     = "swedencentral"
}

variable "custom_domain" {
  type      = string
  default   = "philipwelz.cloud"
  sensitive = true
}

variable "host" {
  type      = string
  default   = "chat"
  sensitive = true
}

###########################################
# LibreChat
###########################################

variable "search_enabled" {
  type        = bool
  description = "Enables Meili Search"
  default     = false
}

variable "librechat_version" {
  type        = string
  description = "Libre"
  # renovate: datasource=github-releases depName=danny-avila/LibreChat versioning=hashicorp
  default = "v0.7.6"
}

variable "librechat_endpoints" {
  type = list(object({
    name = string
  }))
  default = [
    {
      name = "openAI"
    },
    {
      name = "azureOpenAI"
    },
  ]
}

###########################################
# OpenAI
###########################################

variable "openai_enabled" {
  type        = bool
  description = "Enables OpenAI"
  default     = true

}

variable "openai_models" {
  type = list(object({
    name = string
  }))
  default = [
    {
      name = "gpt-4o"
    },
    {
      name = "o1-mini"
    },
    {
      name = "gpt-4o-mini"
    },
  ]
}

###########################################
# Azure OpenAI
###########################################

variable "azure_openai_api_version" {
  type    = string
  default = "2024-08-01-preview"
}

variable "azure_openai_models" {
  type = list(object({
    name                              = string
    version                           = string
    rate_limit_per_minute_in_thousand = number
  }))
  default = [
    {
      name                              = "gpt-4o"
      version                           = "2024-11-20"
      rate_limit_per_minute_in_thousand = 10
    },
    {
      name                              = "o1-mini"
      version                           = "2024-09-12"
      rate_limit_per_minute_in_thousand = 10
    },
  ]
}

###########################################
# Secrets
###########################################

variable "openai_api_key" {
  sensitive = true
}

variable "github_client_secret" {
  sensitive = true
}

variable "github_client_id" {
  sensitive = true
}

# variable "cloudflare_api_token" {
#   sensitive = true
# }
