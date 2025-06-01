
output "public_ip_loadbalancer" {
  value = module.tacoweb.azurerm_public_ip_address
}

output "vmssname" {
  value = azurerm_linux_virtual_machine_scale_set.vmssname.name
}