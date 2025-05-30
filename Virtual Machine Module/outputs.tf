output "resource_group" {
  value = data.azurerm_resource_group.rgname.name
}
output "vnet" {
  value = data.azurerm_virtual_network.vnet.name
}
output "subnet" {
  value = data.azurerm_subnet.subnet.name

}

output "ipaddress" {
  value = azurerm_public_ip.pip.ip_address
}