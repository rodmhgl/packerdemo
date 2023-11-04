resource "azurerm_network_security_rule" "block-all" {
  name                        = "BlockAll"
  priority                    = 4096
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_address_prefix       = "*"
  source_port_range           = "*"
  destination_address_prefix  = "*"
  destination_port_range      = "*"
  network_security_group_name = azurerm_network_security_group.packer_nsg.name
  resource_group_name         = azurerm_resource_group.this.name
}

resource "azurerm_network_security_rule" "allow-vnet-ssh" {
  name                        = "IBA-SSH-VNET"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_address_prefix       = "VirtualNetwork"
  source_port_range           = "*"
  destination_address_prefix  = "10.0.2.0/24"
  destination_port_range      = "22"
  network_security_group_name = azurerm_network_security_group.packer_nsg.name
  resource_group_name         = azurerm_resource_group.this.name
}

resource "azurerm_network_security_rule" "allow-vnet-winrm" {
  name                        = "IBA-WINRMHTTPS-VNET"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_address_prefix       = "VirtualNetwork"
  source_port_range           = "*"
  destination_address_prefix  = "10.0.2.0/24"
  destination_port_range      = "5986"
  network_security_group_name = azurerm_network_security_group.packer_nsg.name
  resource_group_name         = azurerm_resource_group.this.name
}

resource "azurerm_network_security_group" "packer_nsg" {
  name                = "packerNSG"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_subnet_network_security_group_association" "packer_subnet_nsg_association" {
  subnet_id                 = azurerm_subnet.packer.id
  network_security_group_id = azurerm_network_security_group.packer_nsg.id
}
