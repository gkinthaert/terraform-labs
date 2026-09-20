terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.5.0"  # latest version as of 9/16/2026
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.9.1"  # latest version as of 9/16/2026  
    }
  }
# configure for the dev environment - details on console
  backend "azurerm" {
     # resource_group_name  = "rg-terraform-state-dev" # will be run out of the shell script
    # storage_account_name = "stxd9szx34tf" # will be run out of the shell script
    # container_name       = "tfstate" # will be run out of the shell script
    # key                  = "observability-dev" # will be run out of the shell script

  }
}

# Configure the Microsoft Azure Provider

provider "azurerm" {
  features {}
  # subscription_id = "4f126fa1-4ecb-4b04-86ef-e26043dd2c81" # will be run out of the shell script
}