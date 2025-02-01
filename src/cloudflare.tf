data "cloudflare_zone" "philipwelz" {
  name = var.custom_domain
}

resource "cloudflare_record" "chat" {
  zone_id = data.cloudflare_zone.philipwelz.id
  name    = var.host
  content = azurerm_container_app.librechat.ingress[0].fqdn
  type    = "CNAME"
  proxied = false
}

resource "cloudflare_record" "verification" {
  zone_id = data.cloudflare_zone.philipwelz.id
  name    = "asuid.chat"
  content = azurerm_container_app.librechat.custom_domain_verification_id
  type    = "TXT"
  proxied = false
}
