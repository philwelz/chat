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

variable "host" {
  type        = string
  description = "Hostname for the Container Apps Custom Domain"
  default     = "chat"
  sensitive   = true
}

###########################################
# LibreChat
###########################################

variable "search_enabled" {
  type        = bool
  description = "Enables Meili Search integration to search messages"
  default     = false
}

variable "librechat_version" {
  type        = string
  description = "LibreChat version"
  # renovate: datasource=github-releases depName=danny-avila/LibreChat versioning=loose
  default = "v0.7.6"
}

variable "librechat_endpoints" {
  type = list(object({
    name = string
  }))
  description = "Values for LibreChat endpoints"
  default = [
    {
      name = "openAI"
    },
    {
      name = "azureOpenAI"
    },
    {
      name = "agents"
    },
  ]
}

###########################################
# Agents
###########################################

variable "agents_enabled" {
  type        = bool
  description = "Enables Agents feature"
  default     = true
}

###########################################
# OpenAI
###########################################

variable "openai_enabled" {
  type        = bool
  description = "Enables OpenAI integration"
  default     = true

}

variable "openai_models" {
  type = list(object({
    name = string
  }))
  description = "Values for enabled OpenAI models"
  default = [
    {
      name = "gpt-4o"
    },
    {
      name = "gpt-4o-mini"
    },
    {
      name = "o3-mini"
    },
  ]
}

###########################################
# Azure OpenAI
###########################################

variable "azure_openai_enabled" {
  type        = bool
  description = "Enables Azure OpenAI integration"
  default     = true

}

variable "azure_openai_api_version" {
  type        = string
  description = "Value for the Azure OpenAI API version"
  default     = "2024-08-01-preview"
}

variable "azure_openai_models" {
  type = list(object({
    name                              = string
    version                           = string
    rate_limit_per_minute_in_thousand = number
  }))
  description = "Values for enabled Azure OpenAI models"
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
  description = "Value for the OpenAI API key"
  sensitive   = true
}

variable "github_client_secret" {
  description = "GitHub App client Id for authentication"
  sensitive   = true
}

variable "github_client_id" {
  description = "GitHub App client secret for authentication"
  sensitive   = true
}

variable "cloudflare_zone_id" {
  description = "Value for the Cloudflare Zone ID"
  sensitive   = true
}

variable "custom_domain" {
  description = "Value for the custom domain"
  sensitive   = true
}
