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
}

# Configure the Microsoft Azure Provider

provider "azurerm" {
  features {}
  subscription_id = "4f126fa1-4ecb-4b04-86ef-e26043dd2c81"
  #subscription_id = "get the subscription id" better to set an environment variable
}