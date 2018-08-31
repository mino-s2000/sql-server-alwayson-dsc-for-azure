provider "azurerm" {
  subscription_id = "${var.azure_service_principal["subscription_id"]}"
  client_id = "${var.azure_service_principal["client_id"]}"
  client_secret = "${var.azure_service_principal["client_secret"]}"
  tenant_id = "${var.azure_service_principal["tenant_id"]}"
}

module "resource_group" {
  source = "./modules/resource_group"

  rg_name = "${local.rg_name}"
  rg_location = "${var.resource_group["location"]}"
}

module "vnet" {
  source = "./modules/vnet"

  rg_name = "${local.rg_name}"
  rg_location = "${var.resource_group["location"]}"
  vnet_name = "${local.vnet_name}"
  vnet_address_prefix = "${var.vnet["addr_space"]}"
}

module "subnet_ad" {
  source = "./modules/subnet"

  rg_name = "${local.rg_name}"
  rg_location = "${var.resource_group["location"]}"
  vnet_name = "${local.vnet_name}"
  subnet_name = "${local.subnet1_name}"
  subnet_address_prefix = "${var.subnet1["addr_space"]}"
  nsg_name = "${local.nsg1_name}"
}

module "subnet_sql" {
  source = "./modules/subnet"

  rg_name = "${local.rg_name}"
  rg_location = "${var.resource_group["location"]}"
  vnet_name = "${local.vnet_name}"
  subnet_name = "${local.subnet2_name}"
  subnet_address_prefix = "${var.subnet2["addr_space"]}"
  nsg_name = "${local.nsg2_name}"
}

module "pip_dc1" {
  source = "./modules/public_ip"

  rg_name = "${local.rg_name}"
  rg_location = "${var.resource_group["location"]}"
  pip_name = "${local.dc1_pip_name}"
  pip_domain_name = "${local.dc1_pip_domain_name}"
}

module "pip_dc2" {
  source = "./modules/public_ip"

  rg_name = "${local.rg_name}"
  rg_location = "${var.resource_group["location"]}"
  pip_name = "${local.dc2_pip_name}"
  pip_domain_name = "${local.dc2_pip_domain_name}"
}

module "pip_sql1" {
  source = "./modules/public_ip"

  rg_name = "${local.rg_name}"
  rg_location = "${var.resource_group["location"]}"
  pip_name = "${local.sql1_pip_name}"
  pip_domain_name = "${local.sql1_pip_domain_name}"
}

module "pip_sql2" {
  source = "./modules/public_ip"

  rg_name = "${local.rg_name}"
  rg_location = "${var.resource_group["location"]}"
  pip_name = "${local.sql2_pip_name}"
  pip_domain_name = "${local.sql2_pip_domain_name}"
}

module "nic_dc1" {
  source = "./modules/nic"

  rg_name = "${local.rg_name}"
  rg_location = "${var.resource_group["location"]}"
  nic_name = "${local.dc1_nic_name}"
  nic_ipconfig_name = "${local.dc1_nic_ipconfig_name}"
  nic_private_ip_addr = "${var.dc1["addr"]}"
  subnet_id = "${module.subnet_ad.subnet_id}"
  pip_id = "${module.pip_dc1.pip_id}"
}

module "nic_dc2" {
  source = "./modules/nic"

  rg_name = "${local.rg_name}"
  rg_location = "${var.resource_group["location"]}"
  nic_name = "${local.dc2_nic_name}"
  nic_ipconfig_name = "${local.dc2_nic_ipconfig_name}"
  nic_private_ip_addr = "${var.dc2["addr"]}"
  subnet_id = "${module.subnet_ad.subnet_id}"
  pip_id = "${module.pip_dc2.pip_id}"
}

module "nic_sql1" {
  source = "./modules/nic"

  rg_name = "${local.rg_name}"
  rg_location = "${var.resource_group["location"]}"
  nic_name = "${local.sql1_nic_name}"
  nic_ipconfig_name = "${local.sql1_nic_ipconfig_name}"
  nic_private_ip_addr = "${var.sql1["addr"]}"
  subnet_id = "${module.subnet_sql.subnet_id}"
  pip_id = "${module.pip_sql1.pip_id}"
}

module "nic_sql2" {
  source = "./modules/nic"

  rg_name = "${local.rg_name}"
  rg_location = "${var.resource_group["location"]}"
  nic_name = "${local.sql2_nic_name}"
  nic_ipconfig_name = "${local.sql2_nic_ipconfig_name}"
  nic_private_ip_addr = "${var.sql2["addr"]}"
  subnet_id = "${module.subnet_sql.subnet_id}"
  pip_id = "${module.pip_sql2.pip_id}"
}

module "storage_dc1_diag" {
  source = "./modules/storage"

  rg_name = "${local.rg_name}"
  rg_location = "${var.resource_group["location"]}"
  storage_account_name = "${local.dc1_diag_storage_account_name}"
}

module "storage_dc2_diag" {
  source = "./modules/storage"

  rg_name = "${local.rg_name}"
  rg_location = "${var.resource_group["location"]}"
  storage_account_name = "${local.dc2_diag_storage_account_name}"
}

module "storage_sql1_diag" {
  source = "./modules/storage"

  rg_name = "${local.rg_name}"
  rg_location = "${var.resource_group["location"]}"
  storage_account_name = "${local.sql1_diag_storage_account_name}"
}

module "storage_sql2_diag" {
  source = "./modules/storage"

  rg_name = "${local.rg_name}"
  rg_location = "${var.resource_group["location"]}"
  storage_account_name = "${local.sql2_diag_storage_account_name}"
}

module "storage_witness" {
  source = "./modules/storage"

  rg_name = "${local.rg_name}"
  rg_location = "${var.resource_group["location"]}"
  storage_account_name = "${local.cluster_witness_storage_account_name}"
}

module "as_dc" {
  source = "./modules/availability_set"

  rg_name = "${local.rg_name}"
  rg_location = "${var.resource_group["location"]}"
  as_name = "${local.dc1_as_name}"
}

module "as_sql" {
  source = "./modules/availability_set"

  rg_name = "${local.rg_name}"
  rg_location = "${var.resource_group["location"]}"
  as_name = "${local.sql1_as_name}"
}

module "vm_dc1" {
  source = "./modules/vm"

  rg_name = "${local.rg_name}"
  rg_location = "${var.resource_group["location"]}"
  vm_name = "${var.dc1["name"]}"
  vm_size = "${var.dc1["size"]}"
  nic_id = "${module.nic_dc1.nic_id}"
  as_id = "${module.as_dc.as_id}"
  os_disk_name = "${local.dc1_os_disk_name}"
  admin_username = "${var.dc1["admin_username"]}"
  admin_password = "${var.dc1["admin_password"]}"
  blob_endpoint = "${module.storage_dc1_diag.primary_blob_endpoint}"
}

module "vm_dc2" {
  source = "./modules/vm"

  rg_name = "${local.rg_name}"
  rg_location = "${var.resource_group["location"]}"
  vm_name = "${var.dc2["name"]}"
  vm_size = "${var.dc2["size"]}"
  nic_id = "${module.nic_dc2.nic_id}"
  as_id = "${module.as_dc.as_id}"
  os_disk_name = "${local.dc2_os_disk_name}"
  admin_username = "${var.dc2["admin_username"]}"
  admin_password = "${var.dc2["admin_password"]}"
  blob_endpoint = "${module.storage_dc2_diag.primary_blob_endpoint}"
}

module "vm_sql1" {
  source = "./modules/vm"

  rg_name = "${local.rg_name}"
  rg_location = "${var.resource_group["location"]}"
  vm_name = "${var.sql1["name"]}"
  vm_size = "${var.sql1["size"]}"
  nic_id = "${module.nic_sql1.nic_id}"
  as_id = "${module.as_sql.as_id}"
  os_disk_name = "${local.sql1_os_disk_name}"
  admin_username = "${var.sql1["admin_username"]}"
  admin_password = "${var.sql1["admin_password"]}"
  blob_endpoint = "${module.storage_sql1_diag.primary_blob_endpoint}"
}

module "vm_sql2" {
  source = "./modules/vm"

  rg_name = "${local.rg_name}"
  rg_location = "${var.resource_group["location"]}"
  vm_name = "${var.sql2["name"]}"
  vm_size = "${var.sql2["size"]}"
  nic_id = "${module.nic_sql2.nic_id}"
  as_id = "${module.as_sql.as_id}"
  os_disk_name = "${local.sql2_os_disk_name}"
  admin_username = "${var.sql2["admin_username"]}"
  admin_password = "${var.sql2["admin_password"]}"
  blob_endpoint = "${module.storage_sql2_diag.primary_blob_endpoint}"
}

resource "azurerm_automation_account" "am_account" {
  name = "${local.automation_account_name}"
  resource_group_name = "${local.rg_name}"
  location = "${var.resource_group["location"]}"

  sku {
    name = "Basic"
  }
}
