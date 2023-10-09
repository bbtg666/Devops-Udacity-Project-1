resource "azurerm_availability_set" "availability_set" {
  name                = "as-${var.suffix}"
  resource_group_name = var.resource-group-name
  location            = var.location
  platform_fault_domain_count = 2
  platform_update_domain_count = 5
  tags = var.tags
}

resource "azurerm_virtual_machine" "vm" {
  count                 = var.vm-count
  name                  = "vm-${count.index}-${var.suffix}"
  location              = var.location
  resource_group_name   = var.resource-group-name
  network_interface_ids = [element(azurerm_network_interface.ni-vm.*.id, count.index)]
  vm_size               = var.vm-size
  tags                  = var.tags

  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "os-disk-${count.index}-${var.suffix}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  os_profile {
    computer_name  = var.suffix
    admin_username = var.admin-user
    admin_password = var.admin-password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  availability_set_id = azurerm_availability_set.availability_set.id
}

resource "azurerm_network_interface" "ni-vm" {
  count               = var.vm-count
  name                = "ni-${var.suffix}-${count.index}"
  location            = var.location
  resource_group_name = var.resource-group-name
  tags                = var.tags

  ip_configuration {
    name                          = "ipc-internal-vm"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_managed_disk" "md" {
  count                           = var.vm-count
  name                            = "md-vm-${count.index}-${var.suffix}"
  location                        = var.location
  resource_group_name             = var.resource-group-name
  storage_account_type            = "Standard_LRS"
  create_option                   = "Empty"
  disk_size_gb                    = 50
  tags = var.tags
}

resource "azurerm_virtual_machine_data_disk_attachment" "attachment_disk-vm" {
  count              = var.vm-count
  managed_disk_id    = azurerm_managed_disk.md.*.id[count.index]
  virtual_machine_id = azurerm_virtual_machine.vm.*.id[count.index]
  lun                = 10 * count.index
  caching            = "ReadWrite"
}