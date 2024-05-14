terraform {
  backend "azurerm" {
    resource_group_name  = "ghaworkshop377298"
    storage_account_name = "ghaworkshop377298"
    container_name       = "state"
  }
}
