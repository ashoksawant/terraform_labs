output "networkname" {
  value = azurerm_virtual_network.vnet2.name

}
output "public_ips_of_vms" {
  value = azurerm_public_ip.pubip[*].ip_address
}