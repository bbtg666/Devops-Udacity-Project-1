output "list-network-interface" {
  value = [for ni in azurerm_network_interface.ni-vm : ni.id]
}
