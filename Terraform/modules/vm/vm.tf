variable "rg_name" {}
variable "rg_location" {}
variable "vm_name" {}
variable "vm_size" {}
variable "nic_id" {}
variable "as_id" {}
variable "os_disk_name" {}
variable "admin_username" {}
variable "admin_password" {}
variable "blob_endpoint" {}

resource "azurerm_virtual_machine" "vm" {
  name = "${var.vm_name}"
  location = "${var.rg_location}"
  resource_group_name = "${var.rg_name}"
  vm_size = "${var.vm_size}"
  network_interface_ids = ["${var.nic_id}"]
  availability_set_id = "${var.as_id}"

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer = "WindowsServer"
    sku = "2016-Datacenter"
    version = "latest"
  }

  storage_os_disk {
    name = "${var.os_disk_name}"
    managed_disk_type = "Standard_LRS"
    caching = "ReadWrite"
    create_option = "FromImage"
  }

  os_profile {
    computer_name = "${var.vm_name}"
    admin_username = "${var.admin_username}"
    admin_password = "${var.admin_password}"
  }

  os_profile_windows_config {
    timezone = "Tokyo Standard Time"
  }

  boot_diagnostics {
    enabled = true
    storage_uri = "${var.blob_endpoint}"
  }
}
