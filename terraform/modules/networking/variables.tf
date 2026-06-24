variable "name_prefix"        { type = string }
variable "resource_group_name" { type = string }
variable "location"            { type = string }

variable "vnet_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "container_apps_subnet_cidr" {
  type    = string
  default = "10.0.0.0/23"
}

variable "tags" {
  type    = map(string)
  default = {}
}
