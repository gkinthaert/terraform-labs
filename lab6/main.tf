resource "azurerm_resource_group" "main" {
  name     = "rg-${var.application_name}-${var.environment_name}"
  location = var.primary_location
}

# public IP address
resource "azurerm_public_ip" "vm1" {
  name                = "pip-${var.application_name}-${var.environment_name}-vm1"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  allocation_method   = "Static"
}

# we need to get the subnet id for the network interface, so we need to create a virtual network and a subnet first

data "azurerm_subnet" "beta" {
  name                 = "snet-beta"
  virtual_network_name = "vnet-network-dev"
  resource_group_name  = "rg-network-dev"
}

# network interface
resource "azurerm_network_interface" "vm1" {
  name                = "nic-${var.application_name}-${var.environment_name}-vm1"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "public"
    subnet_id                     = data.azurerm_subnet.beta.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm1.id
  }
}

# RSA key of size 4096 bits
resource "tls_private_key" "vm1" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# create a local file to store the private key and public key
/* no longer needed since we are storing the private key in the key vault, but leaving it here for reference
resource "local_file" "private_key" {
  content  = tls_private_key.vm1.private_key_pem
  filename = pathexpand("~/.ssh/vm1")
  file_permission = "0600"
}
resource "local_file" "public_key" {
  content  = tls_private_key.vm1.public_key_openssh
  filename = pathexpand("~/.ssh/vm1.pub")
}
*/

# key vault to store the private key - data source to get the existing key vault, and then create a secret in that key vault to store the private key
data "azurerm_key_vault" "main" {
  name                = "kv-devops-dev"
  resource_group_name = "rg-devops-dev"
}
# this is the key vault that we created in lab5, and we are going to use it to store the private key for the vm1
resource "azurerm_key_vault_secret" "vm1_ssh_private" {
  name         = "vm1-ssh-private"
  value        = tls_private_key.vm1.private_key_pem
  key_vault_id = data.azurerm_key_vault.main.id
}

resource "azurerm_key_vault_secret" "vm1_ssh_public" {
  name         = "vm1-ssh-public"
  value        = tls_private_key.vm1.public_key_openssh
  key_vault_id = data.azurerm_key_vault.main.id
}

resource "azurerm_linux_virtual_machine" "vm1" {
  name                = "vm1${var.application_name}-${var.environment_name}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = "Standard_D2ds_v7"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.vm1.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = tls_private_key.vm1.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}