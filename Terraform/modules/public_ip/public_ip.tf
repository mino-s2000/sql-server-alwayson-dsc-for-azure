variable "rg_name" {}
variable "rg_location" {}
variable "pip_name" {}
variable "pip_domain_name" {}

resource "azurerm_public_ip" "pip" {
  name = "${var.pip_name}"
  location = "${var.rg_location}"
  resource_group_name = "${var.rg_name}"
  public_ip_address_allocation = "Static"
  domain_name_label = "${var.pip_domain_name}"
}

output "pip_id" {
  value = "${azurerm_public_ip.pip.id}"
}
