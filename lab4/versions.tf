terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.3.0" # latest version as of 8/28/2026
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.9.0" # latest version as of 8/28/2026  
    }
  }
  # configure for the dev environment - details on console
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state-dev"
    storage_account_name = "stxd9szx34tf"
    container_name       = "tfstate"
    key                  = "devops-dev"
  }
}



# Configure the Microsoft Azure Provider

provider "azurerm" {
  features {}
  subscription_id = "4f126fa1-4ecb-4b04-86ef-e26043dd2c81"

}

# This resource will trigger provider registration if needed
resource "azurerm_resource_provider_registration" "keyvault" {
  name = "Microsoft.KeyVault"
}

