variable "rg_name" {}
variable "rg_location" {}
variable "nic_name" {}
variable "nic_ipconfig_name" {}
variable "nic_private_ip_addr" {}
variable "subnet_id" {}
variable "pip_id" {}

resource "azurerm_network_interface" "nic" {
  name = "${var.nic_name}"
  location = "${var.rg_location}"
  resource_group_name = "${var.rg_name}"

  ip_configuration {
    name = "${var.nic_ipconfig_name}"
    subnet_id = "${var.subnet_id}"
    private_ip_address_allocation = "Static"
    private_ip_address = "${var.nic_private_ip_addr}"
    public_ip_address_id = "${var.pip_id}"
  }
}

output "nic_id" {
  value = "${azurerm_network_interface.nic.id}"
}
