data "cloudflare_zone" "default" {
  name = var.custom_domain
}

resource "cloudflare_record" "librechat" {
  zone_id = data.cloudflare_zone.default.id
  name    = var.host
  content = azurerm_container_app.librechat.ingress[0].fqdn
  type    = "CNAME"
  proxied = false
}

resource "cloudflare_record" "verification" {
  zone_id = data.cloudflare_zone.default.id
  name    = "asuid.chat"
  content = azurerm_container_app.librechat.custom_domain_verification_id
  type    = "TXT"
  proxied = false
}
