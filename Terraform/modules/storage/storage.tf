variable "rg_name" {}
variable "rg_location" {}
variable "storage_account_name" {}

resource "azurerm_storage_account" "storage" {
  name                     = "${var.storage_account_name}"
  location                 = "${var.rg_location}"
  resource_group_name      = "${var.rg_name}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

output "primary_blob_endpoint" {
  value = "${azurerm_storage_account.storage.primary_blob_endpoint}"
}
