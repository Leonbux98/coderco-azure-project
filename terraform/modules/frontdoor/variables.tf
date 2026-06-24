variable "name_prefix"          { type = string }
variable "resource_group_name"  { type = string }
variable "container_app_fqdn"   { type = string }

variable "custom_domain_hostname" {
  type    = string
  default = ""
}

variable "sku_name" {
  type    = string
  default = "Standard_AzureFrontDoor"
}

variable "tags" {
  type    = map(string)
  default = {}
}
