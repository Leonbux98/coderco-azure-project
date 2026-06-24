resource "azurerm_cdn_frontdoor_profile" "fd" {
  name                = "${var.name_prefix}-fd"
  resource_group_name = var.resource_group_name
  sku_name            = var.sku_name
  tags                = var.tags
}

resource "azurerm_cdn_frontdoor_endpoint" "ep" {
  name                     = "${var.name_prefix}-ep"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd.id
  tags                     = var.tags
}

resource "azurerm_cdn_frontdoor_origin_group" "og" {
  name                     = "${var.name_prefix}-og"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd.id

  load_balancing {
    sample_size                        = 4
    successful_samples_required        = 3
    additional_latency_in_milliseconds = 50
  }

  health_probe {
    path                = "/health"
    request_type        = "GET"
    protocol            = "Https"
    interval_in_seconds = 30
  }
}

resource "azurerm_cdn_frontdoor_origin" "app_origin" {
  name                          = "${var.name_prefix}-origin"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.og.id
  enabled                       = true
  host_name                     = var.container_app_fqdn
  origin_host_header            = var.container_app_fqdn
  http_port                     = 80
  https_port                    = 443
  priority                      = 1
  weight                        = 1000
  certificate_name_check_enabled = true
}

resource "azurerm_cdn_frontdoor_custom_domain" "custom" {
  count = var.custom_domain_hostname != "" ? 1 : 0

  name                     = "${var.name_prefix}-custom-domain"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd.id
  host_name                = var.custom_domain_hostname

  tls {
    certificate_type = "ManagedCertificate"
  }
}

resource "azurerm_cdn_frontdoor_route" "route" {
  name                            = "${var.name_prefix}-route"
  cdn_frontdoor_endpoint_id       = azurerm_cdn_frontdoor_endpoint.ep.id
  cdn_frontdoor_origin_group_id   = azurerm_cdn_frontdoor_origin_group.og.id
  cdn_frontdoor_origin_ids        = [azurerm_cdn_frontdoor_origin.app_origin.id]
  cdn_frontdoor_custom_domain_ids = var.custom_domain_hostname != "" ? [azurerm_cdn_frontdoor_custom_domain.custom[0].id] : []
  forwarding_protocol             = "HttpsOnly"
  https_redirect_enabled          = true
  patterns_to_match               = ["/*"]
  supported_protocols             = ["Http", "Https"]
  link_to_default_domain          = true
}

resource "azurerm_cdn_frontdoor_custom_domain_association" "custom" {
  count = var.custom_domain_hostname != "" ? 1 : 0

  cdn_frontdoor_custom_domain_id = azurerm_cdn_frontdoor_custom_domain.custom[0].id
  cdn_frontdoor_route_ids        = [azurerm_cdn_frontdoor_route.route.id]
}
