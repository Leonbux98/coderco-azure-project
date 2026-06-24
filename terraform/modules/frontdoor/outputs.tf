output "frontdoor_endpoint_url" { value = "https://${azurerm_cdn_frontdoor_endpoint.ep.host_name}" }
output "frontdoor_profile_id"   { value = azurerm_cdn_frontdoor_profile.fd.id }
