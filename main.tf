terraform {
  required_version = "~> 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.0"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_policy_set_definition" "nzism" {
  display_name = "New Zealand ISM Restricted"
}

locals {
  parameters = jsonencode({
    "MembersToExclude-69bf4abd-ca1e-4cf6-8b5a-762d42e61d4f" = {
      value = ""
    }
    "MembersToInclude-30f71ea1-ac77-4f26-9fc5-2d926bbd4ba7" = {
      value = ""
    }
  })
}

resource "azurerm_resource_group" "scope" {
  count    = var.resource_group_name == null ? 0 : 1
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_resource_group_policy_assignment" "nzism" {
  count                = var.resource_group_name == null ? 0 : 1
  name                 = "nzism-rg"
  policy_definition_id = data.azurerm_policy_set_definition.nzism.id
  resource_group_id    = azurerm_resource_group.scope[0].id
  location             = var.location
  not_scopes           = []
  parameters           = local.parameters

  identity {
    type = "SystemAssigned"
  }
}

data "azurerm_subscription" "scope" {
  count           = var.subscription_id == null ? 0 : 1
  subscription_id = var.subscription_id
}

resource "azurerm_subscription_policy_assignment" "nzism" {
  count                = var.subscription_id == null ? 0 : 1
  name                 = "nzism-sub"
  policy_definition_id = data.azurerm_policy_set_definition.nzism.id
  subscription_id      = data.azurerm_subscription.scope[0].id
  location             = var.location
  not_scopes           = []
  parameters           = local.parameters

  identity {
    type = "SystemAssigned"
  }
}

data "azurerm_management_group" "scope" {
  count = var.management_group_name == null ? 0 : 1
  name  = var.management_group_name
}

resource "azurerm_management_group_policy_assignment" "nzism" {
  count                = var.management_group_name == null ? 0 : 1
  name                 = "nzism-mg"
  policy_definition_id = data.azurerm_policy_set_definition.nzism.id
  management_group_id  = data.azurerm_management_group.scope[0].id
  location             = var.location
  not_scopes           = []
  parameters           = local.parameters

  identity {
    type = "SystemAssigned"
  }
}
