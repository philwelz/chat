locals {
  # Common tags to be assigned to all resources
  common_tags = {
    env        = var.stage
    managedBy  = data.azurerm_client_config.current.client_id
    deployedBy = "terraform"
    owner      = "PWE"
  }
  librechat_endpoints = concat(
    var.openai_enabled ? ["openAI"] : [],
    var.azure_openai_enabled ? ["azureOpenAI"] : [],
    var.agents_enabled ? ["agents"] : []
  )
  # Librechat config variables
  # https://www.librechat.ai/docs/configuration/dotenv
  chat_env_vars = {
    HELP_AND_FAQ_URL             = "https://librechat.ai"
    APP_TITLE                    = "Chat"
    CUSTOM_FOOTER                = "Made with ❤️"
    SESSION_EXPIRY               = "1000 * 60 * 15"
    REFRESH_TOKEN_EXPIRY         = "(1000 * 60 * 60 * 24) * 7"
    SHOW_BIRTHDAY_ICON           = true
    NO_INDEX                     = true # Prevent Public Search Engines Indexing
    CONSOLE_JSON                 = false
    SHOW_BIRTHDAY_ICON           = false
    DEBUG_LOGGING                = true # Keep debug logs active.
    DEBUG_CONSOLE                = true # Enable verbose console/stdout logs in the same format as file debug logs.
    DEBUG_OPENAI                 = false
    DEBUG_PLUGINS                = false
    BAN_VIOLATIONS               = false
    LOGIN_VIOLATION_SCORE        = 1
    REGISTRATION_VIOLATION_SCORE = 1
    CONCURRENT_VIOLATION_SCORE   = 1
    MESSAGE_VIOLATION_SCORE      = 1
    NON_BROWSER_VIOLATION_SCORE  = 20
    LIMIT_CONCURRENT_MESSAGES    = false
    LIMIT_MESSAGE_USER           = false
    CHECK_BALANCE                = false
    DOMAIN_CLIENT                = "https://${var.host}.${var.custom_domain}"
    DOMAIN_SERVER                = "https://${var.host}.${var.custom_domain}"
    ALLOW_REGISTRATION           = false
    ALLOW_EMAIL_LOGIN            = false
    ALLOW_PASSWORD_RESET         = false
    LLOW_UNVERIFIED_EMAIL_LOGIN  = false
    ALLOW_SOCIAL_LOGIN           = true
    ALLOW_SOCIAL_REGISTRATION    = false
    GITHUB_CLIENT_ID             = var.github_client_id
    GITHUB_CALLBACK_URL          = "/oauth/github/callback"
  }
}
