# outputs.tf

# Output the public IP address of the web server VM
output "webserver_public_ip" {
  description = "The public IP address of the web server VM"
  value       = azurerm_public_ip.pip_webserver.ip_address
}

# Output the private IP address of the web server NIC
output "webserver_private_ip" {
  description = "The private IP address of the web server NIC"
  value       = azurerm_network_interface.nic_webserver.private_ip_address
}

# Output the resource group name
output "resource_group_name" {
  description = "The name of the resource group"
  value       = azurerm_resource_group.rg_webserver.name
}

# Output the subnet ID
output "subnet_id" {
  description = "The ID of the subnet used for the web server"
  value       = azurerm_subnet.subnet_webserver.id
}

# Output the Network Security Group ID
output "network_security_group_id" {
  description = "The ID of the Network Security Group applied to the subnet"
  value       = azurerm_network_security_group.nsg_webserver.id
}

# Output the Virtual Network name
output "virtual_network_name" {
  description = "The name of the virtual network"
  value       = azurerm_virtual_network.vnet_webserver.name
}

# Output the VM ID
output "vm_id" {
  description = "The ID of the Linux virtual machine"
  value       = azurerm_linux_virtual_machine.vm_webserver.id
}

# Output the VM admin username
output "vm_admin_username" {
  description = "The admin username for the Linux virtual machine"
  value       = azurerm_linux_virtual_machine.vm_webserver.admin_username
}
