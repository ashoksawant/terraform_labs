data "azurerm_resource_group" "main" {
  name = var.resource_group_name

}
resource "azurerm_virtual_network" "main" {
  name                = var.vnetname
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  address_space       = var.address_space
}
