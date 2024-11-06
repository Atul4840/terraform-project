# Resource Group
resource "azurerm_resource_group" "rg_webserver" {
  name     = "rg-webserver"
  location = var.location
}

# Virtual Network
resource "azurerm_virtual_network" "vnet_webserver" {
  name                = "vnet-webserver"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg_webserver.location
  resource_group_name = azurerm_resource_group.rg_webserver.name
}

# Network Security Group with inbound rule for HTTP (port 80) and SSH (port 22)
resource "azurerm_network_security_group" "nsg_webserver" {
  name                = "nsg-webserver"
  location            = azurerm_resource_group.rg_webserver.location
  resource_group_name = azurerm_resource_group.rg_webserver.name

  security_rule {
    name                       = "allow_http"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow_ssh"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Subnet without NSG
resource "azurerm_subnet" "subnet_webserver" {
  name                 = "subnet-webserver"
  resource_group_name  = azurerm_resource_group.rg_webserver.name
  virtual_network_name = azurerm_virtual_network.vnet_webserver.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Associate NSG with the Subnet
resource "azurerm_subnet_network_security_group_association" "nsg_assoc_webserver" {
  subnet_id                 = azurerm_subnet.subnet_webserver.id
  network_security_group_id = azurerm_network_security_group.nsg_webserver.id
}

# Public IP for the VM with dynamic allocation
resource "azurerm_public_ip" "pip_webserver" {
  name                = "pip-webserver"
  location            = azurerm_resource_group.rg_webserver.location
  resource_group_name = azurerm_resource_group.rg_webserver.name
  allocation_method   = "Dynamic"
}

# Network Interface with Public IP
resource "azurerm_network_interface" "nic_webserver" {
  name                = "nic-webserver"
  location            = azurerm_resource_group.rg_webserver.location
  resource_group_name = azurerm_resource_group.rg_webserver.name

  ip_configuration {
    name                          = "ipconfig-webserver"
    subnet_id                     = azurerm_subnet.subnet_webserver.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip_webserver.id
  }
}

# Virtual Machine Configuration
resource "azurerm_linux_virtual_machine" "vm_webserver" {
  name                   = "vm-webserver"
  resource_group_name    = azurerm_resource_group.rg_webserver.name
  location               = azurerm_resource_group.rg_webserver.location
  size                   = "Standard_B1s"
  admin_username         = var.admin_username
  disable_password_authentication = false

  admin_ssh_key {
    username   = var.admin_username
    public_key = file("~/.ssh/azure_key.pub")
  }

  network_interface_ids = [azurerm_network_interface.nic_webserver.id]

  os_disk {
    caching       = "ReadWrite"
    storage_account_type = "Standard_LRS" 
    disk_size_gb  = 30
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}
