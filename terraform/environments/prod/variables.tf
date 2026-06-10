variable "name_prefix" {
  type    = string
  default = "coderco-tm"
}

variable "environment" {
  type    = string
  default = "prod"
}

variable "location" {
  type    = string
  default = "uksouth"
}

variable "image_name" {
  type    = string
  default = "task-manager"
}

variable "image_tag" {
  type    = string
  default = "latest"
}

variable "min_replicas" {
  type    = number
  default = 1
}

variable "max_replicas" {
  type    = number
  default = 3
}

variable "custom_domain_hostname" {
  type    = string
  default = ""
}

variable "tags" {
  type    = map(string)
  default = {}
}
