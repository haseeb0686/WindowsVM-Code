
locals {
  resource_group_name = "haseeb-rg"
  location            = "eastus"
}

variable "azurerm_virtual_network" {

  type = map(object({
    name             = string
    location         = string
    address_space = list(string)
    
        subnets = map(object({
        name             = string
        address_prefixes = string
        }))
  }))

  default = {
    "vnet" = {
      name          = "vnet-001"
      location      = "eastus"
      address_space = ["10.0.0.0/16"]
      address_prefixes = "10.0.0.0/16"

      subnets = {
        "app" = {
          name             = "subnet-app"
          address_prefixes = "10.0.1.0/24"
        },
        "db" = {
          name             = "subnet-db"
          address_prefixes = "10.0.2.0/24"
        },
        "web" = {
          name             = "subnet-web"
          address_prefixes = "10.0.3.0/24"
        }
      }

    }
  }
}