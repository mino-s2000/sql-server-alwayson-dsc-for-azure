variable "rg_name" {}
variable "rg_location" {}
variable "vnet_name" {}
variable "vnet_address_prefix" {}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.vnet_name}"
  address_space       = ["${var.vnet_address_prefix}"]
  location            = "${var.rg_location}"
  resource_group_name = "${var.rg_name}"
}
