

output "azurerm_storage_account_name" {

  value = azurerm_storage_account.stg[*].name

}

output "azurerm_storage_account_id" {

  value = azurerm_storage_account.stg[*].id

}

resource "random_uuid" "stg" {
}


output "random_uuid" {
  value = random_uuid.stg.result
}

output "storage_name" {
  value = "stg${substr(random_uuid.stg.result, 0, 8)}"
}