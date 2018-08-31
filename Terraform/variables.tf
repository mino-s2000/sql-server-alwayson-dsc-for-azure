variable "azure_service_principal" {
  type = "map"

  default = {
    subscription_id = ""
    client_id = ""
    client_secret = ""
    tenant_id = ""
  }
}

variable "resource_name_prefix" {
  default = "DSCTest"
}

variable "resource_group" {
  type = "map"

  default = {
    name_suffix = "RG"
    location = "japaneast"
  }
}

variable "automation_account" {
  type = "map"

  default = {
    name_suffix = "Automation"
  }
}

variable "cluster_witness_storage_account" {
  type = "map"

  default = {
    name_suffix = "sqlwitness"
  }
}

variable "vnet" {
  type = "map"

  default = {
    name_suffix = "Net"
    addr_space = "10.0.0.0/16"
  }
}

variable "subnet1" {
  type = "map"

  default = {
    name_suffix = "ADSubnet"
    addr_space = "10.0.0.0/24"
    nsg_name_suffix = "ADNSG"
  }
}

variable "subnet2" {
  type = "map"

  default = {
    name_suffix = "SQLSubnet"
    addr_space = "10.0.1.0/24"
    nsg_name_suffix = "SQLNSG"
  }
}

variable "dc1" {
  type = "map"

  default = {
    name = "DC01"
    addr = "10.0.0.4"
    size = "Standard_A1_v2"
    admin_username = "azureuser"
    admin_password = "1qazZAQ!1qazZAQ!"
    as_name_suffix = "ADAS"
  }
}

variable "dc2" {
  type = "map"

  default = {
    name = "DC02"
    addr = "10.0.0.5"
    size = "Standard_A1_v2"
    admin_username = "azureuser"
    admin_password = "1qazZAQ!1qazZAQ!"
    as_name_suffix = "ADAS"
  }
}

variable "sql1" {
  type = "map"

  default = {
    name = "SQL01"
    addr = "10.0.1.4"
    size = "Standard_A1_v2"
    admin_username = "azureuser"
    admin_password = "1qazZAQ!1qazZAQ!"
    as_name_suffix = "SQLAS"
  }
}

variable "sql2" {
  type = "map"

  default = {
    name = "SQL02"
    addr = "10.0.1.5"
    size = "Standard_A1_v2"
    admin_username = "azureuser"
    admin_password = "1qazZAQ!1qazZAQ!"
    as_name_suffix = "SQLAS"
  }
}

locals {
  rg_name = "${format("%s%s", var.resource_name_prefix, var.resource_group["name_suffix"])}"

  automation_account_name = "${format("%s%s", var.resource_name_prefix, var.automation_account["name_suffix"])}"

  cluster_witness_storage_account_name = "${format("dsc%s", var.cluster_witness_storage_account["name_suffix"])}"

  vnet_name = "${format("%s%s", var.resource_name_prefix, var.vnet["name_suffix"])}"
  subnet1_name = "${format("%s%s", var.resource_name_prefix, var.subnet1["name_suffix"])}"
  nsg1_name = "${format("%s%s", var.resource_name_prefix, var.subnet1["nsg_name_suffix"])}"
  subnet2_name = "${format("%s%s", var.resource_name_prefix, var.subnet2["name_suffix"])}"
  nsg2_name = "${format("%s%s", var.resource_name_prefix, var.subnet2["nsg_name_suffix"])}"

  dc1_pip_name = "${format("%sPIP", var.dc1["name"])}"
  dc1_pip_domain_name = "${format("dsc-%s", lower(var.dc1["name"]))}"
  dc1_nic_name = "${format("%sNic", var.dc1["name"])}"
  dc1_nic_ipconfig_name = "${format("%sIPConfig", var.dc1["name"])}"
  dc1_diag_storage_account_name = "${format("dsc%sdiag", lower(var.dc1["name"]))}"
  dc1_os_disk_name = "${format("%s-OS", var.dc1["name"])}"
  dc1_as_name = "${format("%s%s", var.resource_name_prefix, var.dc1["as_name_suffix"])}"

  dc2_pip_name = "${format("%sPIP", var.dc2["name"])}"
  dc2_pip_domain_name = "${format("dsc-%s", lower(var.dc2["name"]))}"
  dc2_nic_name = "${format("%sNic", var.dc2["name"])}"
  dc2_nic_ipconfig_name = "${format("%sIPConfig", var.dc2["name"])}"
  dc2_diag_storage_account_name = "${format("dsc%sdiag", lower(var.dc2["name"]))}"
  dc2_os_disk_name = "${format("%s-OS", var.dc2["name"])}"
  dc2_as_name = "${format("%s%s", var.resource_name_prefix, var.dc2["as_name_suffix"])}"

  sql1_pip_name = "${format("%sPIP", var.sql1["name"])}"
  sql1_pip_domain_name = "${format("dsc-%s", lower(var.sql1["name"]))}"
  sql1_nic_name = "${format("%sNic", var.sql1["name"])}"
  sql1_nic_ipconfig_name = "${format("%sIPConfig", var.sql1["name"])}"
  sql1_diag_storage_account_name = "${format("dsc%sdiag", lower(var.sql1["name"]))}"
  sql1_os_disk_name = "${format("%s-OS", var.sql1["name"])}"
  sql1_as_name = "${format("%s%s", var.resource_name_prefix, var.sql1["as_name_suffix"])}"

  sql2_pip_name = "${format("%sPIP", var.sql2["name"])}"
  sql2_pip_domain_name = "${format("dsc-%s", lower(var.sql2["name"]))}"
  sql2_nic_name = "${format("%sNic", var.sql2["name"])}"
  sql2_nic_ipconfig_name = "${format("%sIPConfig", var.sql2["name"])}"
  sql2_diag_storage_account_name = "${format("dsc%sdiag", lower(var.sql2["name"]))}"
  sql2_os_disk_name = "${format("%s-OS", var.sql2["name"])}"
  sql2_as_name = "${format("%s%s", var.resource_name_prefix, var.sql2["as_name_suffix"])}"
}
