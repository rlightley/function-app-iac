terraform {
  #   backend "azurerm" {
  #   }

  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }

    random = {
      source = "hashicorp/random"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

locals {
  default_tags = {
    Environment = var.environment
    CreatedBy   = "Terraform"
    Project     = var.project_name
  }

  resource_suffix = "${var.project_name}-${var.environment}-${var.location_short}"

  storage_account_name = "sa${var.project_name}${var.environment}${var.location_short}"

  sql_admin_name = "${var.project_name}-${var.environment}-${var.location_short}-sa"
}

resource "random_password" "sql_password" {
  length  = 32
  special = true
  keepers = {
    name = "${local.resource_suffix}-sa"
  }
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-${local.resource_suffix}"
  location = var.location

  tags = local.default_tags
}
