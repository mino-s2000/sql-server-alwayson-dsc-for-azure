variable "rg_name" {}
variable "rg_location" {}
variable "vnet_name" {}
variable "subnet_name" {}
variable "subnet_address_prefix" {}
variable "nsg_name" {}

resource "azurerm_subnet" "subnet" {
  name = "${var.subnet_name}"
  resource_group_name = "${var.rg_name}"
  virtual_network_name = "${var.vnet_name}"
  address_prefix = "${var.subnet_address_prefix}"
  network_security_group_id = "${azurerm_network_security_group.nsg.id}"
}

resource "azurerm_network_security_group" "nsg" {
  name = "${var.nsg_name}"
  location = "${var.rg_location}"
  resource_group_name = "${var.rg_name}"

  security_rule {
    name = "RDP"
    priority = 1001
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    source_address_prefixes = [
      "0.0.0.0"
    ]
    destination_port_range = "3389"
    destination_address_prefix = "VirtualNetwork"
  }
}

output "subnet_id" {
  value = "${azurerm_subnet.subnet.id}"
}
