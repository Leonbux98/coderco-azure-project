output "acr_login_server" {
  value = module.acr.acr_login_server
}

output "container_app_url" {
  value = module.container_app.app_url
}

output "frontdoor_url" {
  value = module.frontdoor.frontdoor_endpoint_url
}
