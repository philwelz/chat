# https://github.com/terraform-linters/tflint-ruleset-terraform/blob/main/docs/rules/README.md
plugin "terraform" {
    enabled = true
    preset = "all"
}

# https://github.com/terraform-linters/tflint-ruleset-azurerm
plugin "azurerm" {
    enabled = true
    version = "0.27.0"
    source  = "github.com/terraform-linters/tflint-ruleset-azurerm"
}


rule "terraform_unused_declarations" {
  enabled = false
}
