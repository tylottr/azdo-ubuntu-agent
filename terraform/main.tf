##########
# SSH Key
##########
resource "tls_private_key" "azdo" {
  algorithm = "RSA"
}

#################
# Resource Group
#################
resource "azurerm_resource_group" "azdo" {
  name     = "${local.resource_prefix}-rg"
  location = var.location
  tags     = var.tags
}

##################
# Virtual Network
##################
resource "azurerm_virtual_network" "azdo" {
  name                = "${local.resource_prefix}-vnet"
  resource_group_name = azurerm_resource_group.azdo.name
  location            = var.location
  tags                = var.tags

  address_space = ["10.10.0.0/24"]
}

resource "azurerm_subnet" "azdo" {
  name                = "azdo"
  resource_group_name = azurerm_resource_group.azdo.name

  virtual_network_name = azurerm_virtual_network.azdo.name
  address_prefixes     = [azurerm_virtual_network.azdo.address_space[0]]
}

##########
# Compute
##########
resource "azurerm_linux_virtual_machine_scale_set" "azdo" {
  name                = "${local.resource_prefix}-vmss"
  resource_group_name = azurerm_resource_group.azdo.name
  location            = var.location
  tags                = var.tags

  sku       = var.vm_size
  instances = 1

  admin_username = "vmadmin"
  admin_ssh_key {
    username   = "vmadmin"
    public_key = tls_private_key.azdo.public_key_openssh
  }

  source_image_id = var.vm_source_image_id

  os_disk {
    storage_account_type = var.vm_disk_type
    disk_size_gb         = var.vm_disk_size_gb
    caching              = var.vm_disk_caching
  }

  network_interface {
    name    = "primary"
    primary = true

    ip_configuration {
      name      = "ipconfig"
      primary   = true
      subnet_id = azurerm_subnet.azdo.id
    }
  }

  upgrade_mode  = "Manual"
  overprovision = false

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [
      tags,
      instances
    ]
  }
}
