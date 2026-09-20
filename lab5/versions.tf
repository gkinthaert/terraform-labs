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

}


# Configure the Microsoft Azure Provider

provider "azurerm" {
  features {}
  subscription_id = "4f126fa1-4ecb-4b04-86ef-e26043dd2c81"

}

