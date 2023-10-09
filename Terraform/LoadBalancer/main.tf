resource "azurerm_public_ip" "pi-lb" {
  name                = "pi-${var.suffix}"
  location            = var.location
  resource_group_name = var.resource-group-name
  allocation_method   = "Static"
  tags                = var.tags
}

resource "azurerm_lb" "lb" {
  name                = "lb-${var.suffix}"
  location            = var.location
  resource_group_name = var.resource-group-name
  tags                = var.tags

  frontend_ip_configuration {
    name                 = "public-ip-address-${var.suffix}"
    public_ip_address_id = azurerm_public_ip.pi-lb.id
  }
}

resource "azurerm_lb_backend_address_pool" "lb-backend-pool" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "lb-backend-pool-${var.suffix}"
  
}

resource "azurerm_network_interface_backend_address_pool_association" "main" {
  count                   = var.vm-count
  network_interface_id    = var.list-network-interface[count.index]
  ip_configuration_name   = "ipc-internal-vm"
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb-backend-pool.id
}

resource "azurerm_lb_probe" "lb-probe" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "probe-http"
  port            = 80
}

resource "azurerm_lb_rule" "lb-rules" {
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "Rule-HTTP"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "public-ip-address-${var.suffix}"
}


