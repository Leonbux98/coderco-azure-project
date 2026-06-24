variable "name_prefix"         { type = string }
variable "resource_group_name" { type = string }
variable "location"            { type = string }
variable "acr_id"              { type = string }
variable "acr_login_server"    { type = string }

variable "image_name" {
  type    = string
  default = "task-manager"
}

variable "image_tag" {
  type    = string
  default = "latest"
}

variable "subnet_id" {
  type    = string
  default = ""
}

variable "min_replicas" {
  type    = number
  default = 1
}

variable "max_replicas" {
  type    = number
  default = 3
}

variable "cpu" {
  type    = string
  default = "0.25"
}

variable "memory" {
  type    = string
  default = "0.5Gi"
}

variable "tags" {
  type    = map(string)
  default = {}
}
