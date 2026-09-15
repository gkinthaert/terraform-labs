resource "azurerm_resource_group" "main" {
  name     = "rg-${var.application_name}-${var.environment_name}"
  location = var.primary_location
}

# virtual network - opting not to use nested subnets!
resource "azurerm_virtual_network" "main" {
  name                = "vnet-${var.application_name}-${var.environment_name}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = [var.base_address_space]
}

# locals for the subnets - using cidrsubnet to create 4 /24 subnets from the base address space

locals {
  #alpha_address_space = cidrsubnet(var.base_address_space, 2, 0)
  #beta_address_space  = cidrsubnet(var.base_address_space, 2, 1)
  #gamma_address_space = cidrsubnet(var.base_address_space, 2, 2)
  #delta_address_space = cidrsubnet(var.base_address_space, 2, 3)
  bastion_address_space = cidrsubnet(var.base_address_space, 4, 0)
  beta_address_space  = cidrsubnet(var.base_address_space, 2, 1)
  gamma_address_space = cidrsubnet(var.base_address_space, 2, 2)
  delta_address_space = cidrsubnet(var.base_address_space, 2, 3)
}


# subnets

# 10.39.0.0/24  we are not using this subnet, but leaving it here for reference - we are going 
# to set up a bastion host in this subnet in a future lab, so we will leave it here for now
/*
resource "azurerm_subnet" "alpha" {
  name                 = "snet-alpha"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [local.alpha_address_space]
}
*/

# 10.39.0.0/26
# ip addresses from 10.39.0.0 to 10.39.0.63
resource "azurerm_subnet" "bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [local.bastion_address_space]
}


# 10.39.1.0/24
resource "azurerm_subnet" "beta" {
  name                 = "snet-beta"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [local.beta_address_space]
}
# 10.39.2.0/24
resource "azurerm_subnet" "gamma" {
  name                 = "snet-gamma"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [local.gamma_address_space]
}
# 10.39.3.0/24
resource "azurerm_subnet" "delta" {
  name                 = "snet-delta"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [local.delta_address_space]
}

# we won't use this anymore to access the vms in the lab, since we are going to use a bastion host instead.  But leaving it here for reference
/*
resource "azurerm_network_security_group" "remote_access" {
  name                = "sg-${var.application_name}-${var.environment_name}-remote_access"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = chomp(data.http.my_ip.response_body) # this is the public IP address of the machine you are running terraform from
    destination_address_prefix = "*"
  }
}
*/

# remoed the nsg association for the alpha subnet, since we are not using that subnet in this lab
/* 
resource "azurerm_subnet_network_security_group_association" "alpha_remote_access" {
  subnet_id                 = azurerm_subnet.alpha.id
  network_security_group_id = azurerm_network_security_group.remote_access.id
}
*/

data "http" "my_ip" {
  url = "https://api.ipify.org"
}

resource "azurerm_public_ip" "bastion" {
  name                = "pip-${var.application_name}-${var.environment_name}-bastion"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "main" {  # named it this way because there will only be one bastion host in this lab, so we can just call it main
  name                = "bas-${var.application_name}-${var.environment_name}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.bastion.id
    public_ip_address_id = azurerm_public_ip.bastion.id
  }
}