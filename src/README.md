<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 1.11.1 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 4.22.0 |
| <a name="requirement_cloudflare"></a> [cloudflare](#requirement\_cloudflare) | 5.1.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.7.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.22.0 |
| <a name="provider_cloudflare"></a> [cloudflare](#provider\_cloudflare) | 5.1.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_naming"></a> [naming](#module\_naming) | Azure/naming/azurerm | 0.4.2 |

## Resources

| Name | Type |
|------|------|
| [azurerm_cognitive_account.openai](https://registry.terraform.io/providers/hashicorp/azurerm/4.22.0/docs/resources/cognitive_account) | resource |
| [azurerm_cognitive_deployment.azure_openai_models](https://registry.terraform.io/providers/hashicorp/azurerm/4.22.0/docs/resources/cognitive_deployment) | resource |
| [azurerm_container_app.librechat](https://registry.terraform.io/providers/hashicorp/azurerm/4.22.0/docs/resources/container_app) | resource |
| [azurerm_container_app.search](https://registry.terraform.io/providers/hashicorp/azurerm/4.22.0/docs/resources/container_app) | resource |
| [azurerm_container_app_custom_domain.librechat](https://registry.terraform.io/providers/hashicorp/azurerm/4.22.0/docs/resources/container_app_custom_domain) | resource |
| [azurerm_container_app_environment.librechat](https://registry.terraform.io/providers/hashicorp/azurerm/4.22.0/docs/resources/container_app_environment) | resource |
| [azurerm_cosmosdb_account.librechat](https://registry.terraform.io/providers/hashicorp/azurerm/4.22.0/docs/resources/cosmosdb_account) | resource |
| [azurerm_resource_group.core](https://registry.terraform.io/providers/hashicorp/azurerm/4.22.0/docs/resources/resource_group) | resource |
| [cloudflare_dns_record.librechat](https://registry.terraform.io/providers/cloudflare/cloudflare/5.1.0/docs/resources/dns_record) | resource |
| [cloudflare_dns_record.verification](https://registry.terraform.io/providers/cloudflare/cloudflare/5.1.0/docs/resources/dns_record) | resource |
| [random_string.cosmosdb_root_password](https://registry.terraform.io/providers/hashicorp/random/3.7.1/docs/resources/string) | resource |
| [random_string.creds_iv](https://registry.terraform.io/providers/hashicorp/random/3.7.1/docs/resources/string) | resource |
| [random_string.creds_key](https://registry.terraform.io/providers/hashicorp/random/3.7.1/docs/resources/string) | resource |
| [random_string.jwt_refresh_secret](https://registry.terraform.io/providers/hashicorp/random/3.7.1/docs/resources/string) | resource |
| [random_string.jwt_secret](https://registry.terraform.io/providers/hashicorp/random/3.7.1/docs/resources/string) | resource |
| [random_string.meilisearch_master_key](https://registry.terraform.io/providers/hashicorp/random/3.7.1/docs/resources/string) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/4.22.0/docs/data-sources/client_config) | data source |
| [cloudflare_zone.default](https://registry.terraform.io/providers/cloudflare/cloudflare/5.1.0/docs/data-sources/zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_agents_enabled"></a> [agents\_enabled](#input\_agents\_enabled) | Enables Agents feature | `bool` | `true` | no |
| <a name="input_azure_openai_api_version"></a> [azure\_openai\_api\_version](#input\_azure\_openai\_api\_version) | Value for the Azure OpenAI API version | `string` | `"2024-08-01-preview"` | no |
| <a name="input_azure_openai_enabled"></a> [azure\_openai\_enabled](#input\_azure\_openai\_enabled) | Enables Azure OpenAI integration | `bool` | `true` | no |
| <a name="input_azure_openai_models"></a> [azure\_openai\_models](#input\_azure\_openai\_models) | Values for enabled Azure OpenAI models | <pre>list(object({<br/>    name                              = string<br/>    version                           = string<br/>    rate_limit_per_minute_in_thousand = number<br/>  }))</pre> | <pre>[<br/>  {<br/>    "name": "gpt-4o",<br/>    "rate_limit_per_minute_in_thousand": 10,<br/>    "version": "2024-11-20"<br/>  },<br/>  {<br/>    "name": "gpt-4o-mini",<br/>    "rate_limit_per_minute_in_thousand": 10,<br/>    "version": "2024-07-18"<br/>  },<br/>  {<br/>    "name": "o1",<br/>    "rate_limit_per_minute_in_thousand": 10,<br/>    "version": "2024-12-17"<br/>  },<br/>  {<br/>    "name": "o3-mini",<br/>    "rate_limit_per_minute_in_thousand": 10,<br/>    "version": "2025-01-31"<br/>  }<br/>]</pre> | no |
| <a name="input_cloudflare_zone_id"></a> [cloudflare\_zone\_id](#input\_cloudflare\_zone\_id) | Value for the Cloudflare Zone ID | `string` | n/a | yes |
| <a name="input_custom_domain"></a> [custom\_domain](#input\_custom\_domain) | Value for the custom domain | `string` | n/a | yes |
| <a name="input_github_client_id"></a> [github\_client\_id](#input\_github\_client\_id) | GitHub App client secret for authentication | `string` | n/a | yes |
| <a name="input_github_client_secret"></a> [github\_client\_secret](#input\_github\_client\_secret) | GitHub App client Id for authentication | `string` | n/a | yes |
| <a name="input_host"></a> [host](#input\_host) | Hostname for the Container Apps Custom Domain | `string` | `"chat"` | no |
| <a name="input_librechat_version"></a> [librechat\_version](#input\_librechat\_version) | LibreChat version | `string` | `"v0.7.7"` | no |
| <a name="input_location"></a> [location](#input\_location) | The location used for all resources | `string` | `"swedencentral"` | no |
| <a name="input_openai_api_key"></a> [openai\_api\_key](#input\_openai\_api\_key) | Value for the OpenAI API key | `string` | n/a | yes |
| <a name="input_openai_enabled"></a> [openai\_enabled](#input\_openai\_enabled) | Enables OpenAI integration | `bool` | `true` | no |
| <a name="input_openai_models"></a> [openai\_models](#input\_openai\_models) | Values for enabled OpenAI models | <pre>list(object({<br/>    name = string<br/>  }))</pre> | <pre>[<br/>  {<br/>    "name": "gpt-4o"<br/>  },<br/>  {<br/>    "name": "gpt-4o-mini"<br/>  },<br/>  {<br/>    "name": "o3-mini"<br/>  }<br/>]</pre> | no |
| <a name="input_search_enabled"></a> [search\_enabled](#input\_search\_enabled) | Enables Meilisearch integration to search messages | `bool` | `false` | no |
| <a name="input_search_version"></a> [search\_version](#input\_search\_version) | Meilisearch version | `string` | `"v1.13.3"` | no |
| <a name="input_stage"></a> [stage](#input\_stage) | (Required) The suffix for the resources created in the specified environment | `string` | `"openai"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->