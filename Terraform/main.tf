terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.75.0"
    }
  }
  
}

provider "azurerm" {
    features {}
}

module "resource_group" {
  source = "./ResourceGroup"
  location = var.location
  suffix = var.suffix
  tags = var.tag-project-1
}

module "vitrual-network" {
  source = "./VNET"
  lb-front-end-ip = module.load-balancer.public_ip_address
  resource-group-name = module.resource_group.name
  location = module.resource_group.location
  suffix = var.suffix
  tags = var.tag-project-1
}

module "vitrual-machine" {
  source = "./VM"
  vm-count = var.vm-count
  resource-group-name = module.resource_group.name
  subnet_id = module.vitrual-network.subnet_id
  location = module.resource_group.location
  suffix = var.suffix
  tags = var.tag-project-1
}

module "load-balancer" {
  source = "./LoadBalancer"
  vm-count = var.vm-count
  list-network-interface = module.vitrual-machine.list-network-interface
  resource-group-name = module.resource_group.name
  location = module.resource_group.location
  suffix = var.suffix
  tags = var.tag-project-1
}
