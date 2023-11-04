resource "azurerm_resource_group" "this" {
  name     = "rg-packer-playground"
  location = "eastus"
}

resource "random_id" "nic" {
  byte_length = 3
  keepers = {
    vm_hash = random_id.vm.hex
  }
}

resource "azurerm_network_interface" "this" {
  name                = "this-vm-${random_id.vm.hex}-nic-${random_id.nic.hex}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vm.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.this.id
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "azurerm_public_ip" "this" {
  name                = "this-vm-${random_id.vm.hex}-ip-${random_id.nic.hex}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  sku                 = "Standard"
  allocation_method   = "Static"

  lifecycle {
    create_before_destroy = true
  }
}

resource "random_id" "vm" {
  byte_length = 3
  keepers = {
    # name                   = "${var.name}"
    location            = azurerm_resource_group.this.location
    resource_group_name = azurerm_resource_group.this.name
    # disk_storage           = "${var.os_disk.storage_account_type}"
    # ephemeral_disk         = "${var.os_disk.ephemeral_disk}"
    # admin_username         = "${var.admin_username}"
    # secure_boot_enabled    = "${var.secure_boot_enabled}"
    source_image_id        = var.source_image_id
    source_image_publisher = var.source_image_publisher
    source_image_offer     = var.source_image_offer
    source_image_sku       = var.source_image_sku
    source_image_version   = var.source_image_version
  }
}

resource "azurerm_linux_virtual_machine" "this" {
  name                = "this-machine-${random_id.vm.hex}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.this.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_id = var.source_image_id == null ? null : var.source_image_id

  dynamic "source_image_reference" {
    for_each = var.source_image_id == null ? [1] : []
    content {
      publisher = var.source_image_publisher
      offer     = var.source_image_offer
      sku       = var.source_image_sku
      version   = var.source_image_version
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}
