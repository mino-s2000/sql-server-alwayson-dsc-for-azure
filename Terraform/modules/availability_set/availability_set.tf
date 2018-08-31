variable "rg_name" {}
variable "rg_location" {}
variable "as_name" {}

resource "azurerm_availability_set" "as" {
  name = "${var.as_name}"
  resource_group_name = "${var.rg_name}"
  location = "${var.rg_location}"
  managed = true
  platform_fault_domain_count = 2
}

output "as_id" {
  value = "${azurerm_availability_set.as.id}"
}
