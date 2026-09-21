terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.5.0" # latest version as of 9/16/2026
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.9.0" # latest version as of 9/20/2026
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.9.1" # latest version as of 9/16/2026  
    }
  }
  backend "azurerm" {

  }
}


# Configure the Microsoft Azure Provider

provider "azurerm" {
  features {
    key_vault {
      purge_soft_deleted_secrets_on_destroy = true
      recover_soft_deleted_secrets          = true
    }
  }
  #subscription_id = "4f126fa1-4ecb-4b04-86ef-e26043dd2c81"

}

