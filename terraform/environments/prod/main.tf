terraform {
  required_version = ">= 1.7.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.110"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.name_prefix}-${var.environment}"
  location = var.location
  tags     = local.tags
}

module "networking" {
  source = "../../modules/networking"

  name_prefix                = "${var.name_prefix}-${var.environment}"
  resource_group_name        = azurerm_resource_group.rg.name
  location                   = var.location
  vnet_cidr                  = "10.0.0.0/16"
  container_apps_subnet_cidr = "10.0.0.0/23"
  tags                       = local.tags
}

module "acr" {
  source = "../../modules/acr"

  acr_name            = "${replace(var.name_prefix, "-", "")}${var.environment}acr"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  sku                 = "Basic"
  tags                = local.tags
}

module "container_app" {
  source = "../../modules/container-app"

  name_prefix         = "${var.name_prefix}-${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  acr_id              = module.acr.acr_id
  acr_login_server    = module.acr.acr_login_server
  image_name          = var.image_name
  image_tag           = var.image_tag
  subnet_id           = module.networking.container_apps_subnet_id
  min_replicas        = var.min_replicas
  max_replicas        = var.max_replicas
  tags                = local.tags
}

module "frontdoor" {
  source = "../../modules/frontdoor"

  name_prefix            = "${var.name_prefix}-${var.environment}"
  resource_group_name    = azurerm_resource_group.rg.name
  container_app_fqdn     = module.container_app.app_fqdn
  custom_domain_hostname = var.custom_domain_hostname
  sku_name               = "Standard_AzureFrontDoor"
  tags                   = local.tags
}

locals {
  tags = merge(var.tags, {
    Environment = var.environment
    Project     = "coderco-task-manager"
    ManagedBy   = "terraform"
  })
}
