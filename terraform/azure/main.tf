provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "mini-pipeline-rg"
  location = var.location
}

resource "azurerm_storage_account" "sa" {
  name                     = "minipipelinest"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

variable "location" {
  type    = string
  default = "eastus"
}
