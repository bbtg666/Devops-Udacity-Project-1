resource "azurerm_resource_group" "resource-group" {
  name = "rg-${var.suffix}"
  location = var.location
  tags = var.tags
}