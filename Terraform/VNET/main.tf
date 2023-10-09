
resource "azurerm_virtual_network" "vn" {
  name                = "vn-${var.suffix}"
  location            = var.location
  resource_group_name = var.resource-group-name
  address_space       = ["10.0.0.0/16"]
  tags                = var.tags
}

resource "azurerm_subnet" "subnet-vm" {
  name                 = "sn-${var.suffix}"
  resource_group_name  = var.resource-group-name
  virtual_network_name = azurerm_virtual_network.vn.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-${var.suffix}"
  location            = var.location
  resource_group_name = var.resource-group-name
  tags                = var.tags
}

resource "azurerm_subnet_network_security_group_association" "main" {
  subnet_id                 = azurerm_subnet.subnet-vm.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_network_security_rule" "allow_load_balancer" {
  name                        = "allow_load_balancer"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = var.lb-front-end-ip
  destination_address_prefix  = azurerm_subnet.subnet-vm.address_prefixes[0]
  resource_group_name         = var.resource-group-name
  network_security_group_name = azurerm_network_security_group.nsg.name
}
