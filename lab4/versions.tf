terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.5.0" # latest version as of 9/16/2026
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.9.1" # latest version as of 9/16/2026  
    }
  }
  # configure for the dev environment - details on console
  backend "azurerm" {
    # resource_group_name  = "rg-terraform-state-dev" # set this up in bash file as an environment variable
    #storage_account_name = "stxd9szx34tf" # set this up in bash file as an environment variable
    #container_name       = "tfstate" # set this up in bash file as an environment variable
    # key                  = "devops-dev" # set this up in bash file as an environment variable
  }
}



# Configure the Microsoft Azure Provider

provider "azurerm" {
  features {}
  # subscription_id = "4f126fa1-4ecb-4b04-86ef-e26043dd2c81" # set this up in bashrc file as an environment variable

}
/*
# This resource will trigger provider registration if needed
resource "azurerm_resource_provider_registration" "keyvault" {
  name = "Microsoft.KeyVault"
}
*/
