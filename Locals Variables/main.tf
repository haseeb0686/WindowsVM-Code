

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "my-rg" {
  name     = local.resource_group_name
  location = local.location
}

# The following example shows how to generate a unique name for an Azure Resource Group.




resource "azurerm_storage_account" "stg" {

  count                    = 3
  name                     = "${count.index + 1}stg${substr(random_uuid.stg.result, 0, 8)}"
  resource_group_name      = local.resource_group_name
  location                 = local.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "staging"
  }

  depends_on = [azurerm_resource_group.my-rg]
}

resource "azurerm_storage_container" "hk_container" {

  count                 = 3
  name                  = "${count.index + 1}haseeb-container"
  storage_account_id    = azurerm_storage_account.stg[count.index].id
  container_access_type = "private"


}

resource "azurerm_storage_blob" "my_blob" {

  count                  = 3
  name                   = "${count.index + 1}my-awesome-content.zip"
  storage_account_name   = azurerm_storage_account.stg[count.index].name
  storage_container_name = azurerm_storage_container.hk_container[count.index].name
  type                   = "Block"
  source                 = "c:\\terraform-azure-vm\\Locals Variables\\haseeb.txt"
}

# vnet and subnet example

resource "azurerm_network_security_group" "mynsg" {
  name                = "nsg-001"
  location            = local.location
  resource_group_name = local.resource_group_name

  depends_on = [azurerm_resource_group.my-rg]
}

resource "azurerm_virtual_network" "myvnet" {

  for_each            = var.azurerm_virtual_network
  name                = each.value.name
  location            = each.value.location
  resource_group_name = local.resource_group_name
  address_space       = each.value.address_space
  

  
  depends_on = [azurerm_resource_group.my-rg]

}

resource "azurerm_subnet" "subnets" {
  for_each             = var.azurerm_virtual_network["vnet"].subnets
  name                 = each.value.name
  resource_group_name  = local.resource_group_name
  virtual_network_name = azurerm_virtual_network.myvnet["vnet"].name
  address_prefixes     = [each.value.address_prefixes]
}

resource "azurerm_subnet_network_security_group_association" "nsglink" {

    for_each = var.azurerm_virtual_network["vnet"].subnets
  subnet_id                 = azurerm_subnet.subnets[each.key].id
  network_security_group_id = azurerm_network_security_group.mynsg.id
}